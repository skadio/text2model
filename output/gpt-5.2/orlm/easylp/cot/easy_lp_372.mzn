% Parameters (with values embedded)
int: n = 4;
set of int: TASKS = 1..n;

int: maxHours = 24;
array[TASKS] of int: cost = [3, 4, 5, 6]; % costs per hour for X1..X4

% Variables
array[TASKS] of var 0..maxHours: x; % x[1]=X1, x[2]=X2, x[3]=X3, x[4]=X4 (whole hours)

% Constraints
constraint x[1] + x[2] >= 10;
constraint x[2] + x[3] <= 20;
constraint x[1] >= x[4] + 5;
constraint x[3] <= x[4] + 10;

% Objective
var int: total_cost = sum(i in TASKS)(cost[i] * x[i]);
solve minimize total_cost;

output [
  "X1=", show(x[1]), " X2=", show(x[2]), " X3=", show(x[3]), " X4=", show(x[4]), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];