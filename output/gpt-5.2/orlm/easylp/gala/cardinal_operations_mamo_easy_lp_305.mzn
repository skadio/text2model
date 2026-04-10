include "globals.mzn";

% Data (embedded as required)
int: budget = 5000;
int: min_effectiveness = 3000;
int: logistics_limit = 2500;

int: c1 = 5;
int: c2 = 3;
int: c3 = 7;

% Decision variables: whole-number resource allocations
var 0..budget: X1;
var 0..budget: X2;
var 0..budget: X3;

% Constraints
constraint X1 + X2 + X3 <= budget;

% Environmental effectiveness: 4*X1 + 6*X3 >= 3000
constraint 4 * X1 + 6 * X3 >= min_effectiveness;

% Logistics: 2*X2 + 3*(X3/2) <= 2500
% Enforce integrality by multiplying by 2: 4*X2 + 3*X3 <= 5000
constraint 4 * X2 + 3 * X3 <= 2 * logistics_limit;

% Objective: minimize total cost
var int: total_cost = c1 * X1 + c2 * X2 + c3 * X3;
solve minimize total_cost;

output [
  "X1 = ", show(X1), "\n",
  "X2 = ", show(X2), "\n",
  "X3 = ", show(X3), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];