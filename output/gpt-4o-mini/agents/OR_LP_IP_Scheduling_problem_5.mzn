int: rows;                     % Number of programmers
int: cols;                     % Number of jobs
array[1..rows, 1..cols] of int: cost; % Preference values

% Decision variables: binary matrix for assignment
array[1..rows, 1..cols] of var 0..1: x;

% Each programmer can be assigned to at most one job
constraint forall(i in 1..rows)(
    sum(j in 1..cols)(x[i,j]) <= 1
);

% Each job can be assigned to at most one programmer
constraint forall(j in 1..cols)(
    sum(i in 1..rows)(x[i,j]) <= 1
);

% Objective: Minimize the total preference cost
var int: total_cost = sum(i in 1..rows, j in 1..cols)(cost[i,j] * x[i,j]);
solve minimize total_cost;

% Output the assignment and total cost
output [
    "Total Cost = ", show(total_cost), "\n",
    "Assignment:\n" ++
    concat([ show(x[i,j]) ++ " " | j in 1..cols ] ++ ["\n"] | i in 1..rows)
];