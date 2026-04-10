include "globals.mzn";

% Data (embedded as required)
int: n = 4;
array[1..n] of int: cost = [3, 4, 5, 6];   % $/hour for X1..X4
int: maxHours = 24;

% Decision variables: scheduled whole hours for tasks X1..X4
array[1..n] of var 0..maxHours: x;         % x[1]=X1, x[2]=X2, x[3]=X3, x[4]=X4

% Constraints
constraint x[1] + x[2] >= 10;
constraint x[2] + x[3] <= 20;
constraint x[1] >= x[4] + 5;
constraint x[3] <= x[4] + 10;

% Objective: minimize total cost
var int: total_cost = sum(i in 1..n)(cost[i] * x[i]);
solve minimize total_cost;

output [
  "X1=", show(x[1]), " hours\n",
  "X2=", show(x[2]), " hours\n",
  "X3=", show(x[3]), " hours\n",
  "X4=", show(x[4]), " hours\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];