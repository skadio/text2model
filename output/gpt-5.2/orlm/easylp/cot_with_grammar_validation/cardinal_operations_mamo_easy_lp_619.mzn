% Parameters
int: nTasks = 4;
set of int: TASKS = 1..nTasks;

array[TASKS] of int: maxHours = [10, 15, 20, 25];
array[TASKS] of int: costPerHour = [10, 20, 30, 40];

% Variables
array[TASKS] of var 0..25: X;   % X[1]=X1, X[2]=X2, X[3]=X3, X[4]=X4
var 0..(25 * 40 * nTasks): totalCost;

% Constraints
constraint forall(t in TASKS) (X[t] <= maxHours[t]);

constraint X[1] + X[2] <= 8;
constraint X[2] + X[3] <= 12;
constraint X[3] + X[4] >= 14;

constraint 2 * X[2] - X[1] - X[3] <= -6;

% X3 - 0.5*X4 >= X2  <=>  2*X3 - X4 >= 2*X2
constraint 2 * X[3] - X[4] >= 2 * X[2];

constraint totalCost = sum(t in TASKS)(costPerHour[t] * X[t]);

% Objective
solve minimize totalCost;