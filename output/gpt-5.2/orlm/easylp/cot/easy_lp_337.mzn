% Parameters (with values embedded)
int: n = 4;
set of int: P = 1..n;

array[P] of int: cost = [10, 12, 20, 15]; % X1..X4

array[P] of int: lb = [0, 0, 0, 0];
array[P] of int: ub = [600, 500, 400, 300];

% Variables
array[P] of var int: x; % x[1]=X1, x[2]=X2, x[3]=X3, x[4]=X4
var int: total_cost;

% Constraints
constraint forall(i in P) (lb[i] <= x[i] /\ x[i] <= ub[i]);

% X1 + X2 <= 1000
constraint x[1] + x[2] <= 1000;

% 2*X1 + X3 <= 1500
constraint 2*x[1] + x[3] <= 1500;

% 3*X2 + 2*X4 >= 1200
constraint 3*x[2] + 2*x[4] >= 1200;

% |X3 - X4| <= 500
constraint abs(x[3] - x[4]) <= 500;

% Total cost
constraint total_cost = sum(i in P)(cost[i] * x[i]);

% Objective
solve minimize total_cost;

output [
  "X1=", show(x[1]), " X2=", show(x[2]), " X3=", show(x[3]), " X4=", show(x[4]), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];