% Parameters
int: max_total_units = 500;          % Upper bound on total production X+Y+Z
int: min_weighted_output = 100;      % Lower bound on 3X - Y + Z
int: max_other_constraint = 200;     % Upper bound on X - 2Y - Z

int: cost_X = 50;                   % Cost per unit of product X
int: cost_Y = 30;                   % Cost per unit of product Y
int: cost_Z = 20;                   % Cost per unit of product Z


% Variables
var 0..max_total_units: X;          % Integer units of product X
var 0..max_total_units: Y;          % Integer units of product Y
var 0..max_total_units: Z;          % Integer units of product Z

% Total cost (bounded by producing max_total_units of each; safe upper bound)
var 0..(cost_X*max_total_units + cost_Y*max_total_units + cost_Z*max_total_units): total_cost;


% Constraints
% Total production capacity constraint: X + Y + Z <= max_total_units
constraint
  X + Y + Z <= max_total_units;

% Market demand / production balance constraint: 3X - Y + Z >= min_weighted_output
constraint
  3 * X - Y + Z >= min_weighted_output;

% Storage/logistics constraint: X - 2Y - Z <= max_other_constraint
constraint
  X - 2 * Y - Z <= max_other_constraint;

% Define total cost
constraint
  total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;


% Objective
solve minimize total_cost;