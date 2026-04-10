% Parameters
% Unit costs ($ per resource unit) for projects X1..X4
int: cost_x1 = 1000;
int: cost_x2 = 2000;
int: cost_x3 = 3000;
int: cost_x4 = 4000;

% Capacity/budget-style upper bounds on combined allocations
int: max_x1_x2 = 500;   % X1 + X2 <= 500
int: max_x3_x4 = 800;   % X3 + X4 <= 800

% Minimum-difference requirements (in resource units)
int: min_diff_x1_x3 = 50;   % 0.5*X1 - 1.25*X3 >= 50
int: min_diff_x4_x2 = 100;  % 0.75*X4 - X2 >= 100

% Individual project bounds
int: x1_lb = 0;   int: x1_ub = 500;
int: x2_lb = 0;   int: x2_ub = 400;
int: x3_lb = 0;   int: x3_ub = 600;
int: x4_lb = 0;   int: x4_ub = 700;


% Variables
% Integer resource allocations to each project
var x1_lb..x1_ub: x1;  % resources allocated to project X1
var x2_lb..x2_ub: x2;  % resources allocated to project X2
var x3_lb..x3_ub: x3;  % resources allocated to project X3
var x4_lb..x4_ub: x4;  % resources allocated to project X4

% Total cost (bounded using worst-case upper bounds)
var 0..(cost_x1*x1_ub + cost_x2*x2_ub + cost_x3*x3_ub + cost_x4*x4_ub): total_cost;


% Constraints
% --- Total cost definition (linear aggregation) ---
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% --- Combined allocation caps (budget/capacity style constraints) ---
constraint
  x1 + x2 <= max_x1_x2;

constraint
  x3 + x4 <= max_x3_x4;

% --- Strategic balance constraints (rewrite to avoid fractional coefficients) ---
% Given: 0.5*X1 - 1.25*X3 >= min_diff_x1_x3
% Multiply by 4: 2*X1 - 5*X3 >= 4*min_diff_x1_x3
constraint
  2 * x1 - 5 * x3 >= 4 * min_diff_x1_x3;

% Given: 0.75*X4 - X2 >= min_diff_x4_x2
% Multiply by 4: 3*X4 - 4*X2 >= 4*min_diff_x4_x2
constraint
  3 * x4 - 4 * x2 >= 4 * min_diff_x4_x2;


% Objective
solve minimize total_cost;