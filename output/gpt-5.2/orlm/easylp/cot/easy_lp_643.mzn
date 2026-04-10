% Parameters (with values embedded)
int: n = 4;
set of int: P = 1..n;

% Project indices: 1=X1, 2=X2, 3=X3, 4=X4
array[P] of int: cost = [4, 2, 3, 5];

% NOTE: The prompt mentions "specific bounds on resource allocation" but does not provide them.
% We therefore use safe non-negative bounds and an upper bound implied by constraints.
int: UB = 10000;

% Variables
array[P] of var 0..UB: x;  % x[1]=X1, x[2]=X2, x[3]=X3, x[4]=X4 (integer allocations)

% Constraints
% |0.5*X2 - X1| <= 100  ->  |X2 - 2*X1| <= 200
constraint x[2] - 2*x[1] <= 200;
constraint 2*x[1] - x[2] <= 200;

% X1 >= 200 + 0.7*X3  ->  10*X1 >= 2000 + 7*X3
constraint 10*x[1] >= 2000 + 7*x[3];

% |X4 - 0.6*X2| <= 150  ->  |10*X4 - 6*X2| <= 1500
constraint 10*x[4] - 6*x[2] <= 1500;
constraint 6*x[2] - 10*x[4] <= 1500;

% |0.8*X3 - X1| <= 300  ->  |4*X3 - 5*X1| <= 1500
constraint 4*x[3] - 5*x[1] <= 1500;
constraint 5*x[1] - 4*x[3] <= 1500;

% X4 >= X2 + 50
constraint x[4] >= x[2] + 50;

% Objective
var int: total_cost = sum(i in P)(cost[i] * x[i]);

solve minimize total_cost;