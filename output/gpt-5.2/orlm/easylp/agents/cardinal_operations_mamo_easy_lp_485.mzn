% Parameters
% Maximum total resources available
int: max_resources = 100;

% Minimum required combined impact
int: min_impact = 300;

% Coefficients in the impact expression: 3*X + 4*Y
int: impact_coeff_x = 3;
int: impact_coeff_y = 4;

% Maximum allowed absolute difference between allocations (balance constraint)
int: max_diff = 20;

% Unit costs for each initiative
int: cost_x = 5;
int: cost_y = 2;

% Variables
% Resource allocation to initiative X (indivisible, whole number)
var 0..max_resources: x;

% Resource allocation to initiative Y (indivisible, whole number)
var 0..max_resources: y;

% Total cost (bounded using max_resources and unit costs)
var 0..(max_resources * (cost_x + cost_y)): total_cost;

% Constraints
% Total resources budget constraint: x + y cannot exceed max_resources
constraint x + y <= max_resources;

% Mission impact constraint: combined impact must be at least min_impact
constraint impact_coeff_x * x + impact_coeff_y * y >= min_impact;

% Balance constraint: absolute difference between allocations bounded by max_diff
constraint abs(x - y) <= max_diff;

% Total cost definition: compute total_cost from unit costs and allocations
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;