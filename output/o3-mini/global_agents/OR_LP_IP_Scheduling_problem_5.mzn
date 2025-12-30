include "globals.mzn";

% Data (provided in the .dzn file)
int: rows;
int: cols;
array[1..rows, 1..cols] of int: cost;

% Decision variables
% For each programmer i (1..rows) assign a distinct job (value in 1..cols)
array[1..rows] of var 1..cols: assign;
constraint all_different(assign);

% Additionally, we define the binary assignment matrix x
% x[i,j] = 1 if programmer i is assigned job j, and 0 otherwise.
array[1..rows, 1..cols] of var 0..1: x;
constraint forall(i in 1..rows, j in 1..cols)(
    x[i,j] = bool2int(assign[i] = j)
);

% Objective: Minimize the sum of preference cost values for the assignments.
var int: total_cost = sum(i in 1..rows)( cost[i, assign[i]] );

solve minimize total_cost;

output [
  "Assignment vector = ", show(assign), "\n",
  "Total cost     = ", show(total_cost), "\n",
  "Assignment matrix x =\n", 
  concat([ show([ fix(x[i,j]) | j in 1..cols ]) ++ "\n" | i in 1..rows ])
];