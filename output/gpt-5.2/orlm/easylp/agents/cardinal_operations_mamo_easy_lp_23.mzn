% Parameters
int: max_total_units = 200;              % Factory capacity limit on total units produced
int: min_weighted_output = 400;          % Minimum required combined output: 3*X + 2*Y >= 400
int: coeff_X = 3;                        % Contribution coefficient for product X in demand constraint
int: coeff_Y = 2;                        % Contribution coefficient for product Y in demand constraint
int: cost_X = 500;                       % Cost per unit of product X (dollars)
int: cost_Y = 300;                       % Cost per unit of product Y (dollars)

% Variables
var 0..max_total_units: units_X;         % Number of units of product X to produce (integer, nonnegative)
var 0..max_total_units: units_Y;         % Number of units of product Y to produce (integer, nonnegative)
var 0..(max_total_units * max(cost_X, cost_Y)): total_cost; % Total production cost (dollars)

% Constraints
% Total units produced cannot exceed factory capacity
constraint
  units_X + units_Y <= max_total_units;

% Demand/throughput constraint: weighted combination must meet minimum requirement
constraint
  coeff_X * units_X + coeff_Y * units_Y >= min_weighted_output;

% Define total cost consistently with unit costs
constraint
  total_cost = cost_X * units_X + cost_Y * units_Y;

% Objective
solve minimize total_cost;