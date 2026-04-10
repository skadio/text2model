% Parameters (with values embedded)
int: max_total_properties = 1000;
int: min_X = 400; % single-family homes
int: min_Y = 250; % multi-family homes
int: min_Z = 350; % commercial buildings

int: cost_X_k = 200; % $k per unit
int: cost_Y_k = 300; % $k per unit
int: cost_Z_k = 150; % $k per unit
int: k_to_dollars = 1000;

% Variables
var 0..max_total_properties: X;
var 0..max_total_properties: Y;
var 0..max_total_properties: Z;

var 0..(max_total_properties * max(cost_X_k, max(cost_Y_k, cost_Z_k)) * k_to_dollars): total_cost_dollars;

% Constraints
constraint X + Y + Z <= max_total_properties;

constraint X >= min_X;
constraint Y >= min_Y;
constraint Z >= min_Z;

constraint total_cost_dollars =
  k_to_dollars * (cost_X_k * X + cost_Y_k * Y + cost_Z_k * Z);

% Objective
solve minimize total_cost_dollars;