% Parameters (with values embedded)
int: max_total = 100;

int: x1_lb = 20; int: x1_ub = 60;
int: x2_lb = 10; int: x2_ub = 40;
int: x3_lb = 15; int: x3_ub = 30;

% Costs in dollars per unit (use tenths of dollars to avoid floats in the solver)
int: c1_tenths = 5;   % 0.5
int: c2_tenths = 3;   % 0.3
int: c3_tenths = 7;   % 0.7

% Variables
var x1_lb..x1_ub: X1;
var x2_lb..x2_ub: X2;
var x3_lb..x3_ub: X3;

var 0..(c1_tenths*x1_ub + c2_tenths*x2_ub + c3_tenths*x3_ub): total_cost_tenths;

% Constraints
constraint X1 + X2 + X3 <= max_total;

% "twice X1 must exceed half of X2 by at least 30"
% 2*X1 >= 0.5*X2 + 30  -> multiply by 2: 4*X1 - X2 >= 60
constraint 4 * X1 - X2 >= 60;

% "X1 minus half of X3 should not exceed 20"
% X1 - 0.5*X3 <= 20 -> multiply by 2: 2*X1 - X3 <= 40
constraint 2 * X1 - X3 <= 40;

constraint total_cost_tenths = c1_tenths * X1 + c2_tenths * X2 + c3_tenths * X3;

% Objective
solve minimize total_cost_tenths;

output [
  "X1=", show(X1), " X2=", show(X2), " X3=", show(X3), "\n",
  "min_cost_dollars_1dp=", show(total_cost_tenths div 10), ".", show(total_cost_tenths mod 10), "\n"
];