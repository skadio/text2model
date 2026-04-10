% Parameters
int: n = 4;
set of int: TASKS = 1..n;

array[TASKS] of int: maxHours = [10, 15, 20, 25];
array[TASKS] of int: costPerHour = [10, 20, 30, 40];

% Variables
array[TASKS] of var 0..25: x; % hours for tasks X1..X4 (integers)
var 0..(25*(10+20+30+40)): totalCost;

% Constraints
constraint forall(i in TASKS) (x[i] <= maxHours[i]);

% Combined duration constraints
constraint x[1] + x[2] <= 8;
constraint x[2] + x[3] <= 12;
constraint x[3] + x[4] >= 14;

% Balance constraints
constraint 2*x[2] - x[1] - x[3] <= -6;
constraint 2*x[3] - x[4] >= 2*x[2];  % x3 - 0.5*x4 >= x2, multiplied by 2

% Objective definition
constraint totalCost = sum(i in TASKS) (costPerHour[i] * x[i]);

% Objective
solve minimize totalCost;