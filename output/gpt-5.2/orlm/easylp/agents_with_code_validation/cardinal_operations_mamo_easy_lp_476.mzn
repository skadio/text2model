% Parameters
int: total_budget_limit = 200;                 % Maximum combined budget for X and Y
float: impact_weight_x = 0.6;                  % Weight for X in impact score
float: impact_weight_y = 0.8;                  % Weight for Y in impact score
float: min_weighted_impact = 120.0;            % Minimum required weighted impact
int: max_x_minus_y = 50;                       % X - Y must be <= 50
int: cost_per_unit_x = 50;                     % Cost per unit for X
int: cost_per_unit_y = 80;                     % Cost per unit for Y
int: max_alloc_x = 150;                        % Upper bound on allocation to X
int: max_alloc_y = 100;                        % Upper bound on allocation to Y

% Variables
var 0..max_alloc_x: x;                         % Whole-number budget allocated to project X
var 0..max_alloc_y: y;                         % Whole-number budget allocated to project Y

var 0..(cost_per_unit_x*max_alloc_x + cost_per_unit_y*max_alloc_y): total_cost;
                                               % Total cost (bounded explicitly)

% Constraints
% --- Budget feasibility constraints ---
constraint x + y <= total_budget_limit;

% --- Weighted impact requirement ---
constraint impact_weight_x * int2float(x) + impact_weight_y * int2float(y) >= min_weighted_impact;

% --- Balance constraint between projects ---
constraint x - y <= max_x_minus_y;

% --- Total cost definition ---
constraint total_cost = cost_per_unit_x * x + cost_per_unit_y * y;

% Objective
solve minimize total_cost;