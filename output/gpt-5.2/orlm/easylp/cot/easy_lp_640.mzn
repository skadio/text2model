% Parameters (with values embedded)
int: n = 4;
set of int: P = 1..n;

% Project indices: 1=X1, 2=X2, 3=X3, 4=X4
array[P] of int: cost = [2, 3, 4, 5];

array[P] of int: lb = [100, 50, 20, 40];
array[P] of int: ub = [800, 600, 400, 200];

% Variables
array[P] of var int: X;
var int: total_cost;

% Constraints
constraint forall(i in P) (lb[i] <= X[i] /\ X[i] <= ub[i]);

% 2*X2 - X1 - X3 + X4 >= 1000
constraint 2*X[2] - X[1] - X[3] + X[4] >= 1000;

% X1 + X3 <= 0.5*X2 + 0.7*X4 + 500
% Multiply by 10 to keep integrality: 10X1 + 10X3 <= 5X2 + 7X4 + 5000
constraint 10*X[1] + 10*X[3] <= 5*X[2] + 7*X[4] + 5000;

% 0.8*X1 + X3 - 0.9*X2 <= 1500
% Multiply by 10: 8X1 + 10X3 - 9X2 <= 15000
constraint 8*X[1] + 10*X[3] - 9*X[2] <= 15000;

% X1 + X2 + X3 + X4 >= 200
constraint sum(i in P)(X[i]) >= 200;

% "difference between about three-fifths of X2 and (X1+X3) cannot exceed 300"
% Interpret as: (X1+X3) - (3/5)X2 <= 300
% Multiply by 5: 5(X1+X3) - 3X2 <= 1500
constraint 5*(X[1] + X[3]) - 3*X[2] <= 1500;

% Objective linkage
constraint total_cost = sum(i in P)(cost[i] * X[i]);

% Objective
solve minimize total_cost;