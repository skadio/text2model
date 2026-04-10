% Parameters
int: max_total_units = 100;          % Total available resources for sourcing + distribution
int: min_weighted_sum = 50;          % Minimum required value for 2*sourcing + distribution
int: max_abs_difference = 30;        % Maximum allowed |sourcing - distribution|

int: cost_sourcing = 2;              % Cost per unit for sourcing (X)
int: cost_distribution = 3;          % Cost per unit for distribution (Y)

% Variables
var 0..max_total_units: sourcing_units;       % X: integer units allocated to sourcing
var 0..max_total_units: distribution_units;   % Y: integer units allocated to distribution

% Upper bound: worst case when both at max_total_units
var 0..(cost_sourcing*max_total_units + cost_distribution*max_total_units): total_cost;

% Constraints
% Total resource availability: sourcing + distribution cannot exceed the budgeted maximum
constraint sourcing_units + distribution_units <= max_total_units;

% Operational balance requirement: weighted minimum on sourcing and distribution
constraint 2 * sourcing_units + distribution_units >= min_weighted_sum;

% Reliance control: allocations must be within the maximum allowed absolute difference
constraint abs(sourcing_units - distribution_units) <= max_abs_difference;

% Cost accounting: define total cost from unit costs and allocations
constraint total_cost = cost_sourcing * sourcing_units + cost_distribution * distribution_units;

% Objective
solve minimize total_cost;