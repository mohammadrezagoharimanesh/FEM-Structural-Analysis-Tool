clear; clc; close all;

nd = load('nodes-1.txt');
el = load('elements-1.txt');
loads = load('loads-1.txt');

numN = size(nd, 1);
numE = size(el, 1);

X = nd(:, 2); Y = nd(:, 3);
DOFs = [nd(:, 4), nd(:, 5)];

K = zeros(2*numN, 2*numN);
F = zeros(2*numN, 1);

for i = 1:size(loads, 1)
    node_num = loads(i, 1);
    fx = loads(i, 2);
    fy = loads(i, 3);
    
    F(2*node_num - 1) = fx;
    F(2*node_num)     = fy;
end

for i = 1:numE
    n1 = el(i, 2); n2 = el(i, 3);
    A = el(i, 4); E = el(i, 5);
    
    idx = [2*n1-1, 2*n1, 2*n2-1, 2*n2];
    
    L = sqrt((X(n2)-X(n1))^2 + (Y(n2)-Y(n1))^2);
    C = (X(n2)-X(n1))/L;
    S = (Y(n2)-Y(n1))/L;
    
    k_loc = (A*E/L) * [ C*C  C*S -C*C -C*S;
                        C*S  S*S -C*S -S*S;
                       -C*C -C*S  C*C  C*S;
                       -C*S -S*S  C*S  S*S];
                   
    K(idx, idx) = K(idx, idx) + k_loc;
end

F_orig = F;
fixed = find(reshape(DOFs', [], 1) == 1);
free = find(reshape(DOFs', [], 1) == 0);

U = zeros(2*numN, 1);
U(free) = K(free, free) \ F(free);

R = K * U - F_orig;

disp('--- NODE DISPLACEMENTS ---');
disp([(1:numN)', U(1:2:end), U(2:2:end)]);

disp('--- SUPPORT REACTIONS ---');
disp([fixed, R(fixed)]);

disp('--- ELEMENT FORCES ---');
EF = zeros(numE, 1);
for i = 1:numE
    n1 = el(i, 2); n2 = el(i, 3);
    A = el(i, 4); E = el(i, 5);
    L = sqrt((X(n2)-X(n1))^2 + (Y(n2)-Y(n1))^2);
    C = (X(n2)-X(n1))/L;
    S = (Y(n2)-Y(n1))/L;
    u = [U(2*n1-1); U(2*n1); U(2*n2-1); U(2*n2)];
    EF(i) = (A*E/L) * [-C, -S, C, S] * u;
end
disp([(1:numE)', EF]);

figure;
hold on;
scale = 1; 
for i = 1:numE
    n1 = el(i, 2); n2 = el(i, 3);
    plot([X(n1), X(n2)], [Y(n1), Y(n2)], 'b-');
    plot([X(n1)+scale*U(2*n1-1), X(n2)+scale*U(2*n2-1)], ...
         [Y(n1)+scale*U(2*n1), Y(n2)+scale*U(2*n2)], 'r--', 'LineWidth', 1);
end
for i = 1:numN
    text(X(i)+0.5, Y(i)+0.5, num2str(i), 'Color', 'k', 'FontWeight', 'bold', 'FontSize', 10);
end
title('Blue: Original Truss | Red: Deformed Truss (Scale x1)');
axis equal;
grid on;