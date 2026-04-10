% Parameters
% Minimum total investment required across projects
int: min_total_invest = 30;

% Maximum allowed combined resource usage
int: max_resource_usage = 150;

% Resource usage coefficients
int: usage_per_x = 5;
int: usage_per_y = 3;

% Cost per unit investment
int: cost_per_x = 40;
int: cost_per_y = 50;

% Variables
% Integer investments in projects X and Y (non-negative)
var 0..max_resource_usage: invest_x;
var 0..max_resource_usage: invest_y;

% Total cost (bounded above using the same coarse bounds on investments)
var 0..(cost_per_x*max_resource_usage + cost_per_y*max_resource_usage): total_cost;

% Rounded total cost (cost is integral here, so rounding has no effect)
var 0..(cost_per_x*max_resource_usage + cost_per_y*max_resource_usage): total_cost_rounded;

% Constraints
% --- Minimum total investment requirement ---
constraint invest_x + invest_y >= min_total_invest;

% --- Maximum combined resource usage constraint ---
constraint usage_per_x * invest_x + usage_per_y * invest_y <= max_resource_usage;

% --- Define total cost from investments ---
constraint total_cost = cost_per_x * invest_x + cost_per_y * invest_y;

% --- Rounded total cost (no-op since total_cost is integral) ---
constraint total_cost_rounded = total_cost;

% Objective
solve minimize total_cost_rounded;