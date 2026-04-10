% Parameters
% Total resources available for both strategies
int: max_total_resources = 5000;

% Minimum required effectiveness score
int: min_effectiveness = 10000;

% Effectiveness coefficients for X and Y
int: eff_x = 2;
int: eff_y = 3;

% Cost per unit resource for strategies X and Y
int: cost_x = 10;
int: cost_y = 20;


% Variables
% Resources allocated to strategy X and Y (integer, non-negative, bounded)
var 0..max_total_resources: x;
var 0..max_total_resources: y;

% Total cost to minimize (bounded using max_total_resources)
var 0..(cost_x * max_total_resources + cost_y * max_total_resources): total_cost;


% Constraints
% Budget/resource limit: total resources allocated across both strategies cannot exceed max_total_resources
constraint x + y <= max_total_resources;

% Minimum effectiveness requirement: combined effectiveness must meet or exceed min_effectiveness
constraint eff_x * x + eff_y * y >= min_effectiveness;

% Total cost definition: link total_cost to decision variables and unit costs
constraint total_cost = cost_x * x + cost_y * y;


% Objective
solve minimize total_cost;