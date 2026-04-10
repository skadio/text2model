% Parameters
% Resource/budget limit
int: total_resource_limit = 1000;

% Production/yield constraint coefficients and RHS
int: coef_yield_X = 4;
int: coef_yield_Y = 5;
int: min_combined_yield = 3000;

% Interdependency constraint coefficients and RHS
int: coef_interdep_Z = 1;
int: coef_interdep_Y = -3;      % Z - 3*Y >= -500  => 1*Z + (-3)*Y >= -500
int: min_interdependency = -500;

% Unit costs
int: cost_X = 2;
int: cost_Y = 3;
int: cost_Z = 1;


% Variables
% Integer allocations to each area (non-negative, bounded by total resources)
var 0..total_resource_limit: x;  % allocation to area X
var 0..total_resource_limit: y;  % allocation to area Y
var 0..total_resource_limit: z;  % allocation to area Z

% Total cost (bounded by max possible cost per unit times total resources)
var 0..(cost_X + cost_Y + cost_Z) * total_resource_limit: total_cost;


% Constraints
% Resource/budget limit: total allocated resources cannot exceed the available limit
constraint x + y + z <= total_resource_limit;

% Production/yield requirement: combined yield from X and Y must meet minimum target
constraint coef_yield_X * x + coef_yield_Y * y >= min_combined_yield;

% Interdependency requirement: relationship between Z and Y must satisfy minimum bound
constraint coef_interdep_Z * z + coef_interdep_Y * y >= min_interdependency;

% Total cost definition: compute total cost from allocations and unit costs
constraint total_cost = cost_X * x + cost_Y * y + cost_Z * z;


% Objective
solve minimize total_cost;