% Parameters
int: total_budget_cap = 200;          % Max combined budget for projects X and Y
float: impact_weight_x = 0.6;         % Weight for impact contributed by X (given, not used directly)
float: impact_weight_y = 0.8;         % Weight for impact contributed by Y (given, not used directly)
float: min_weighted_impact = 120.0;   % Minimum required weighted impact (given, not used directly)
int: max_x_over_y = 50;               % X - Y cannot exceed 50
int: cost_per_unit_x = 50;            % Cost per unit for project X
int: cost_per_unit_y = 80;            % Cost per unit for project Y
int: max_alloc_x = 150;               % Upper bound on allocation to X
int: max_alloc_y = 100;               % Upper bound on allocation to Y

% Variables
var 0..max_alloc_x: alloc_x;          % Integer allocation to project X
var 0..max_alloc_y: alloc_y;          % Integer allocation to project Y

var 0..(cost_per_unit_x*max_alloc_x + cost_per_unit_y*max_alloc_y): total_cost;
                                      % Total cost to be minimized (bounded)

% Constraints
%-------------------------------
% Budget capacity constraint
%-------------------------------
constraint
  alloc_x + alloc_y <= total_budget_cap;

%-------------------------------
% Minimum weighted impact constraint
% Use integer scaling to avoid float var*float issues:
% 0.6*x + 0.8*y >= 120  <=>  6*x + 8*y >= 1200
%-------------------------------
constraint
  6 * alloc_x + 8 * alloc_y >= 1200;

%-------------------------------
% Balance constraint: X should not exceed Y by more than max_x_over_y
%-------------------------------
constraint
  alloc_x - alloc_y <= max_x_over_y;

%-------------------------------
% Total cost definition
%-------------------------------
constraint
  total_cost = cost_per_unit_x * alloc_x + cost_per_unit_y * alloc_y;

% Objective
solve minimize total_cost;