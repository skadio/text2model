% Parameters
% Total available resource units (integer allocations)
int: total_resource_limit = 100;

% Cost per unit (dollars) for each department
float: cost_x1 = 0.5;  % Surgery (X1)   = 5/10
float: cost_x2 = 0.3;  % Internal (X2)  = 3/10
float: cost_x3 = 0.7;  % Diagnostics(X3)= 7/10

% Constraint constants
int: min_gap_surgery_vs_internal = 30;    % 2*X1 - 0.5*X2 >= 30
int: max_gap_surgery_vs_diagnostics = 20; % X1 - 0.5*X3 <= 20

% Bounds (not explicitly provided in the prompt; use natural bounds)
int: x1_lb = 0; int: x1_ub = total_resource_limit;
int: x2_lb = 0; int: x2_ub = total_resource_limit;
int: x3_lb = 0; int: x3_ub = total_resource_limit;


% Variables
var x1_lb..x1_ub: X1;  % units allocated to Surgery
var x2_lb..x2_ub: X2;  % units allocated to Internal medicine
var x3_lb..x3_ub: X3;  % units allocated to Diagnostics

% Total cost scaled by 10 to keep integer arithmetic and allow 1-decimal reporting
% 0.5=5/10, 0.3=3/10, 0.7=7/10 => total_cost10 = 5*X1 + 3*X2 + 7*X3
var 0..(7 * total_resource_limit): total_cost10;


% Constraints
% Resource limit
constraint X1 + X2 + X3 <= total_resource_limit;

% 2*X1 - 0.5*X2 >= 30  ==> multiply by 2: 4*X1 - X2 >= 60
constraint 4 * X1 - X2 >= 2 * min_gap_surgery_vs_internal;

% X1 - 0.5*X3 <= 20  ==> multiply by 2: 2*X1 - X3 <= 40
constraint 2 * X1 - X3 <= 2 * max_gap_surgery_vs_diagnostics;

% Define total cost (scaled by 10)
constraint total_cost10 = 5 * X1 + 3 * X2 + 7 * X3;


% Objective
solve minimize total_cost10;

% (Optional) Output in dollars rounded to one decimal place
output [
  "X1=", show(X1), " X2=", show(X2), " X3=", show(X3), "\n",
  "min_cost=$", show(total_cost10 div 10), ".", show(total_cost10 mod 10), "\n"
];