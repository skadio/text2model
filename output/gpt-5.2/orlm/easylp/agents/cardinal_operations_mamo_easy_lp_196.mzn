% Parameters
int: budget_units = 500;                     % Maximum total investment units allowed
int: min_x_units = 100;                      % Minimum units required in investment X
int: min_y_units = 50;                       % Minimum units required in investment Y
int: min_z_units = 30;                       % Minimum units required in investment Z

int: cost_x_per_unit = 1000;                 % Cost per unit of investment X (dollars)
int: cost_y_per_unit = 1500;                 % Cost per unit of investment Y (dollars)
int: cost_z_per_unit = 2000;                 % Cost per unit of investment Z (dollars)

% Variables
var min_x_units..budget_units: x_units;      % Units invested in X (bounded integer)
var min_y_units..budget_units: y_units;      % Units invested in Y (bounded integer)
var min_z_units..budget_units: z_units;      % Units invested in Z (bounded integer)

var int: total_cost;                         % Total portfolio cost (dollars)

% Constraints
% Total investment units cannot exceed the available budget
constraint x_units + y_units + z_units <= budget_units;

% Total cost calculation from per-unit costs
constraint total_cost =
    cost_x_per_unit * x_units
  + cost_y_per_unit * y_units
  + cost_z_per_unit * z_units;

% Objective
solve minimize total_cost;