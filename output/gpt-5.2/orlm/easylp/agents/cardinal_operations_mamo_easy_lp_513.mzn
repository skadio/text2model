% Parameters
% Cost per unit for each project
int: cost_x1 = 50;
int: cost_x2 = 75;
int: cost_x3 = 120;

% Global resource/budget limits and coefficients
int: max_total_allocation = 500;

int: eff_coef_x1 = 5;
int: eff_coef_x2 = 10;
int: min_effectiveness = 1000;

% Constraint coefficient for X3 is "twice and a half" = 2.5 = 5/2
int: x3_num = 5;   % numerator
int: x3_den = 2;   % denominator

int: max_difference = 300;


% Variables
% Resource allocations (whole numbers, non-negative, and bounded by total limit)
var 0..max_total_allocation: x1;   % units allocated to project X1
var 0..max_total_allocation: x2;   % units allocated to project X2
var 0..max_total_allocation: x3;   % units allocated to project X3

% Total cost (integer dollars)
var 0..(max_total_allocation * max(cost_x1, max(cost_x2, cost_x3))): total_cost;


% Constraints

% --- Total allocation budget limit ---
constraint
  x1 + x2 + x3 <= max_total_allocation;

% --- Minimum effectiveness requirement ---
constraint
  eff_coef_x1 * x1 + eff_coef_x2 * x2 >= min_effectiveness;

% --- Difference constraint: (2.5 * x3) - x1 <= 300 ---
% Avoid non-integer coefficients by multiplying through by x3_den:
% (x3_num/x3_den)*x3 - x1 <= max_difference
% => x3_num*x3 - x3_den*x1 <= max_difference*x3_den
constraint
  x3_num * x3 - x3_den * x1 <= max_difference * x3_den;

% --- Total cost definition (for use in the objective) ---
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;


% Objective
solve minimize total_cost;