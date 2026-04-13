% Parameters
int: n = 4;
set of int: D = 1..n;

array[D] of int: ub = [100, 80, 60, 50];

% Scale costs by 10 to keep integer objective: [0.5,0.2,0.3,0.4] -> [5,2,3,4]
array[D] of int: cost10 = [5, 2, 3, 4];

% Variables
array[D] of var 0..max(ub): x;
var int: total_cost10;

% Constraints
constraint forall(i in D) (x[i] <= ub[i]);

constraint x[1] + x[2] <= 100;
constraint x[2] + x[3] >= 50;
constraint x[3] - x[4] <= 30;

constraint 10*x[1] + 15*x[2] - 5*x[3] - 20*x[4] >= 150;

constraint total_cost10 = sum(i in D)(cost10[i] * x[i]);

% Objective
solve minimize total_cost10;