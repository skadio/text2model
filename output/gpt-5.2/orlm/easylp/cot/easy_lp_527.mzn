% Parameters (with values embedded)
int: BUDGET_MAX = 200;
int: perf_min_scaled = 400;     % scaled by 10: 0.5x1 -0.3x2 +0.4x3 >= 40  -> 5x1 -3x2 +4x3 >= 400
int: diff_max = 70;

int: c1 = 50;
int: c2 = 30;
int: c3 = 20;

% Variables
var 0..BUDGET_MAX: X1;
var 0..BUDGET_MAX: X2;
var 0..BUDGET_MAX: X3;

var 0..(c1*BUDGET_MAX + c2*BUDGET_MAX + c3*BUDGET_MAX): total_cost;

% Constraints
constraint X1 + X2 + X3 <= BUDGET_MAX;

% Performance constraint (scaled by 10 to avoid floats)
constraint 5*X1 - 3*X2 + 4*X3 >= perf_min_scaled;

% Balance constraint
constraint 2*X2 - (X1 + X3) <= diff_max;

% Cost definition
constraint total_cost = c1*X1 + c2*X2 + c3*X3;

% Objective
solve minimize total_cost;

output [
  "X1=", show(X1), " X2=", show(X2), " X3=", show(X3), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];