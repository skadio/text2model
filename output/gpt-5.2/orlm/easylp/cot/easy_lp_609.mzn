% Parameters (with values embedded)
int: n = 4;
set of int: P = 1..n;

int: X1 = 1;
int: X2 = 2;
int: X3 = 3;
int: X4 = 4;

array[P] of int: cost = [1000, 2000, 3000, 4000];

array[P] of int: lb = [0, 0, 0, 0];
array[P] of int: ub = [500, 400, 600, 700];

int: cap12 = 500;
int: cap34 = 800;

% Variables
array[P] of var int: x;
var int: total_cost;

% Constraints
constraint forall(i in P) (lb[i] <= x[i] /\ x[i] <= ub[i]);

constraint x[X1] + x[X2] <= cap12;
constraint x[X3] + x[X4] <= cap34;

% "half of X1 must be at least one-fourth more than X3 by no less than 50 units"
% Interpreted as: (1/2)*X1 - (5/4)*X3 >= 50
% Multiply by 4 to keep integers: 2*X1 - 5*X3 >= 200
constraint 2*x[X1] - 5*x[X3] >= 200;

% "difference between three-quarters of X4 and X2 must be at least 100"
% (3/4)*X4 - X2 >= 100  =>  3*X4 - 4*X2 >= 400
constraint 3*x[X4] - 4*x[X2] >= 400;

% Objective
constraint total_cost = sum(i in P)(cost[i] * x[i]);
solve minimize total_cost;