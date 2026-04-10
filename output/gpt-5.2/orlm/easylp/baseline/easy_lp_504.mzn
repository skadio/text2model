% Marketing budget allocation (integer budgets)
% Minimize total cost subject to constraints

int: X1_max = 5000;
int: X2_max = 4000;
int: X3_max = 3000;
int: total_max = 10000;

int: eff_min = 2000;

% To avoid fractional coefficients, multiply relevant constraints by 4
% Effectiveness: 2*X1 - 3*X2 + 4.5*X3 >= 2000
% Multiply by 2: 4*X1 - 6*X2 + 9*X3 >= 4000
int: eff_min_scaled = 4000;

% Balance constraint:
% (0.5*X2) - (X1 + 0.75*X3) <= 1500
% Multiply by 4: 2*X2 - 4*X1 - 3*X3 <= 6000
int: balance_rhs_scaled = 6000;

% Costs (dollars per unit budget)
int: c1 = 5000;
int: c2 = 3000;
int: c3 = 7000;

var 0..X1_max: x1;
var 0..X2_max: x2;
var 0..X3_max: x3;

constraint x1 + x2 + x3 <= total_max;

constraint 4*x1 - 6*x2 + 9*x3 >= eff_min_scaled;

constraint 2*x2 - 4*x1 - 3*x3 <= balance_rhs_scaled;

var int: total_cost = c1*x1 + c2*x2 + c3*x3;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "minimum_total_cost_dollars=", show(total_cost), "\n"
];