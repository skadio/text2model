% Parameters
int: n = 4;
set of int: P = 1..n;

array[P] of int: cost = [2, 3, 4, 5];

array[P] of int: lb = [100, 50, 20, 40];
array[P] of int: ub = [800, 600, 400, 200];

% Variables
array[P] of var int: x;

% Constraints
constraint forall(i in P) (lb[i] <= x[i] /\ x[i] <= ub[i]);

% 2*X2 - X1 - X3 + X4 >= 1000
constraint 2*x[2] - x[1] - x[3] + x[4] >= 1000;

% X1 + X3 <= 0.5*X2 + 0.7*X4 + 500
% Multiply by 10: 10X1 + 10X3 <= 5X2 + 7X4 + 5000
constraint 10*x[1] + 10*x[3] <= 5*x[2] + 7*x[4] + 5000;

% 0.8*X1 + X3 - 0.9*X2 <= 1500
% Multiply by 10: 8X1 + 10X3 - 9X2 <= 15000
constraint 8*x[1] + 10*x[3] - 9*x[2] <= 15000;

% X1 + X2 + X3 + X4 >= 200
constraint sum(i in P)(x[i]) >= 200;

% |(X1 + X3) - (3/5)*X2| <= 300
% Multiply by 5: |5X1 + 5X3 - 3X2| <= 1500
constraint abs(5*x[1] + 5*x[3] - 3*x[2]) <= 1500;

% Objective
var int: total_cost = sum(i in P)(cost[i] * x[i]);
solve minimize total_cost;