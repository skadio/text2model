include "globals.mzn";

% Parameters
int: r; % Number of rows
int: c; % Number of columns
array[1..r, 1..c] of int: puzzle; % Hidato puzzle grid

% Variables
array[1..r, 1..c] of var 1..(r*c): solution;

% Constraints
constraint forall(i in 1..r, j in 1..c) (
  puzzle[i,j] > 0 -> solution[i,j] = puzzle[i,j]
);

constraint forall(i in 1..r, j in 1..c) (
  puzzle[i,j] = 0 -> solution[i,j] > 0
);

constraint forall(i in 1..r, j in 1..c) (
  let { 
    set of int: Ni = (i-1) union (i+1) intersect 1..r,
    set of int: Nj = (j-1) union (j+1) intersect 1..c
  } in
  forall(ni in Ni, nj in Nj) (
    abs(solution[i,j] - solution[ni,nj]) = 1
  )
);

% Objective
solve satisfy;

% Output
output [ if fix(solution[i,j]) = puzzle[i,j] then " " else show(fix(solution[i,j])) endif | i in 1..r, j in 1..c ];