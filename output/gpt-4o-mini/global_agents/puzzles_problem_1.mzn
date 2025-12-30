include "globals.mzn";

int: n;                          % Number of rows
int: m;                          % Number of columns
array[1..n, 1..m] of int: grid; % The grid of numbers

% Decision variables
array[1..n] of var 1..m: path;  % The column indices selected from each row

% Objective: Maximize the sum of the selected numbers
var int: total_sum = sum(i in 1..n)(grid[i, path[i]]);

% Constraints to ensure valid movement
constraint forall(i in 1..n-1) (
    abs(path[i] - path[i+1]) <= 1  % Can move straight down, down-left, or down-right
);

% Solve the model
solve maximize total_sum;

% Output the results
output [
    "Path = ", show(path), "\n",
    "Total Sum = ", show(total_sum), "\n"
];