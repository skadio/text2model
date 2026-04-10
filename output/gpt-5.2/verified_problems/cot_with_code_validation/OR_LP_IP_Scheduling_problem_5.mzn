% Assignment problem (minimize total preference cost)

% Parameters (must be provided in .dzn)
int: rows;
int: cols;
array[1..rows, 1..cols] of int: cost;

% Decision variables
array[1..rows, 1..cols] of var 0..1: x;

% Each programmer gets exactly one job
constraint forall(i in 1..rows) (
  sum(j in 1..cols) (x[i,j]) = 1
);

% Each job is assigned to exactly one programmer
constraint forall(j in 1..cols) (
  sum(i in 1..rows) (x[i,j]) = 1
);

% Objective: minimize total preference values
solve minimize sum(i in 1..rows, j in 1..cols) (cost[i,j] * x[i,j]);

output [
  "total_cost=", show(sum(i in 1..rows, j in 1..cols) (cost[i,j] * x[i,j])), "\n",
  "x=\n",
  concat([ concat([ if fix(x[i,j]) = 1 then "1 " else "0 " endif | j in 1..cols ]) ++ "\n" | i in 1..rows ])
];