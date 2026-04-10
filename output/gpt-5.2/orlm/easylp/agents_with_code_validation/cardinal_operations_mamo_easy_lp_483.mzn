% Parameters
% Budget/resource limit coefficients and bounds (embedded from problem statement)
int: max_budget = 100;                 % Maximum allowed value of 4*X + 5*Y
int: coef_budget_x = 4;                % Coefficient of X in budget constraint
int: coef_budget_y = 5;                % Coefficient of Y in budget constraint

int: min_total_alloc = 20;             % Minimum required total allocation X + Y

int: max_diff = 30;                    % Maximum allowed value of |2*X - Y|
int: coef_diff_x = 2;                  % Coefficient of X in balance constraint
int: coef_diff_y = 1;                  % Coefficient of Y in balance constraint

int: cost_x = 6;                       % Unit cost for project X
int: cost_y = 2;                       % Unit cost for project Y

% Variables
var 0..100: alloc_x;                   % Allocation to project X (integer, nonnegative)
var 0..100: alloc_y;                   % Allocation to project Y (integer, nonnegative)

var 0..800: total_cost;                % Total cost = 6*X + 2*Y (bounded using max 100 each)

% Constraints
% Budget/resource limit: 4*X + 5*Y <= 100
constraint
  coef_budget_x * alloc_x + coef_budget_y * alloc_y <= max_budget;

% Minimum combined allocation: X + Y >= 20
constraint
  alloc_x + alloc_y >= min_total_alloc;

% Balance constraint: |2*X - Y| <= 30
constraint
  abs(coef_diff_x * alloc_x - coef_diff_y * alloc_y) <= max_diff;

% Total cost definition: total_cost = 6*X + 2*Y
constraint
  total_cost = cost_x * alloc_x + cost_y * alloc_y;

% Objective
solve minimize total_cost;