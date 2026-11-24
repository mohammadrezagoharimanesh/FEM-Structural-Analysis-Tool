# FEM Structural Analysis Tool

Finite element analysis of truss structures, in two forms: a MATLAB script for 2D trusses and an interactive web app for 3D space trusses.

## Contents

| Path | Description |
| --- | --- |
| `matlab/truss_2d_fem.m` | 2D truss solver that reads its model from text files |
| `matlab/nodes-1.txt`, `elements-1.txt`, `loads-1.txt` | Example 1: a 12-node, 22-element truss |
| `matlab/nodes-2.txt`, `elements-2.txt`, `loads-2.txt` | Example 2: a 7-node, 11-element truss |
| `web/space_truss_fem.html` | Browser app for building, solving and viewing 3D trusses |

## MATLAB: 2D truss

Run `truss_2d_fem.m` from inside the `matlab` folder. It prints the node displacements, support reactions and axial force in every element, then plots the original truss (blue) over the deformed one (red).

Input files, one row per item:

| File | Columns |
| --- | --- |
| `nodes-N.txt` | node id, x, y, fixed in x (1 = fixed), fixed in y (1 = fixed) |
| `elements-N.txt` | element id, node 1, node 2, area A, Young's modulus E |
| `loads-N.txt` | node id, Fx, Fy |

The script loads example 1 by default. To run example 2, change the three `load(...)` file names at the top of the script from `-1` to `-2`.

## Web: 3D space truss

Open `web/space_truss_fem.html` in a modern browser (an internet connection is needed to load Three.js). You can:

- Add nodes and elements, set the cross-section area and Young's modulus, and edit or delete them from the lists
- Apply point forces and supports on chosen degrees of freedom
- Choose length, force and modulus units
- Solve, then see node displacements, element stress colours and the deformed shape, and animate it with **Motion**
- Export results as CSV, save projects to the browser history and reload them from a JSON file

## Method

Each member is a two-node bar element that carries axial load only. The element stiffness matrix is built from the member length and direction cosines and assembled into the global matrix. The constrained degrees of freedom are removed, the remaining system is solved for the displacements, and the axial force or stress is then recovered for each member.
