% Parameters
int: n = 4;
set of int: TASKS = 1..n;

array[TASKS] of int: maxHours = [10, 15, 20, 25];
array[TASKS] of int: costPerHour = [10, 20, 30, 40];

% Variables
array[TASKS] of var int: x;
var int: totalCost;

% Constraints
constraint forall(t in TASKS)(0 <= x[t] /\ x[t] <= maxHours[t]);

constraint x[1] + x[2] <= 8;
constraint x[2] + x[3] <= 12;
constraint x[3] + x[4] >= 14;

constraint 2*x[2] - x[1] - x[3] <= -6;

% x3 - 0.5*x4 >= x2  <=>  2*x3 - x4 >= 2*x2
constraint 2*x[3] - x[4] >= 2*x[2];

constraint totalCost = sum(t in TASKS)(costPerHour[t] * x[t]);

% Objective
solve minimize totalCost;