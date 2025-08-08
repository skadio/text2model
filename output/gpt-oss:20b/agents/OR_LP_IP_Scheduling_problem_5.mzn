include "globals.mzn";

int: rows;               % number of programmers
int: cols;               % number of jobs

% preference (cost) matrix – 1 = most preferred, higher numbers = less preferred
array[1..rows, 1..cols] of int: cost;

% binary assignment matrix
array[1..rows, 1..cols] of var 0..1: x;

% each programmer gets exactly one job
constraint forall(i in 1..rows) (
    sum(j in 1..cols) (x[i,j]) == 1
);

% each job is assigned to exactly one programmer
constraint forall(j in 1..cols) (
    sum(i in 1..rows) (x[i,j]) == 1
);

% integer representation of the assignment (used only for output / all_different)
array[1..rows] of var 1..cols: assign;

% the integer assignment must be consistent with the binary matrix
constraint forall(i in 1..rows, j in 1..cols) (
    x[i,j] = bool2int(assign[i] == j)
);

% all jobs must be assigned to different programmers
constraint all_different(assign);

% objective: minimise total preference cost
var int: totalCost = sum(i in 1..rows, j in 1..cols) (cost[i,j] * x[i,j]);

solve minimize totalCost;

output [
    "Total cost: ", show(totalCost), "\n",
    "Assignments (programmer -> job): ", show(assign), "\n"
];