% Resource allocation among three departments with minimum cost
% All data embedded as requested.

% Parameters
int: BUDGET_MAX = 200;

float: perf_x1 = 0.5;
float: perf_x2 = -0.3;
float: perf_x3 = 0.4;
float: PERF_MIN = 40.0;

int: BALANCE_MAX = 70;  % 2*X2 - X1 - X3 <= 70

int: cost_x1 = 50;
int: cost_x2 = 30;
int: cost_x3 = 20;

% Decision variables (whole numbers)
var 0..BUDGET_MAX: x1;
var 0..BUDGET_MAX: x2;
var 0..BUDGET_MAX: x3;

% Constraints
constraint x1 + x2 + x3 <= BUDGET_MAX;

% Performance constraint:
% 0.5*x1 - 0.3*x2 + 0.4*x3 >= 40
% Multiply by 10 to avoid floating arithmetic:
% 5*x1 - 3*x2 + 4*x3 >= 400
constraint 5*x1 - 3*x2 + 4*x3 >= 400;

% Balance constraint
constraint 2*x2 - x1 - x3 <= BALANCE_MAX;

% Objective: minimize total cost
var int: total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "total_cost = ", show(total_cost), "\n"
];