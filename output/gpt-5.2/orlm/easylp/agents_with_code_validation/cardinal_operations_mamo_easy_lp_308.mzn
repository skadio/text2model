% Parameters
int: max_total_units = 10000;        % Logistical limit on total deployed units
int: min_effectiveness = 20000;      % Minimum required combined effectiveness

int: eff_X = 5;                      % Effectiveness contribution per X unit
int: eff_Y = 3;                      % Effectiveness contribution per Y unit
int: eff_Z = 7;                      % Effectiveness contribution per Z unit

int: cost_X = 500;                   % Cost per X unit (dollars)
int: cost_Y = 300;                   % Cost per Y unit (dollars)
int: cost_Z = 700;                   % Cost per Z unit (dollars)

% Variables
var 0..max_total_units: x_units;     % Number of X units to deploy (integer, nonnegative)
var 0..max_total_units: y_units;     % Number of Y units to deploy (integer, nonnegative)
var 0..max_total_units: z_units;     % Number of Z units to deploy (integer, nonnegative)

var 0..(cost_X*max_total_units + cost_Y*max_total_units + cost_Z*max_total_units): total_cost;
                                     % Total deployment cost (bounded above conservatively)

% Constraints

% Total deployed units must not exceed logistical limit
constraint
  x_units + y_units + z_units <= max_total_units;

% Minimum combined effectiveness requirement
constraint
  eff_X * x_units + eff_Y * y_units + eff_Z * z_units >= min_effectiveness;

% Tactical balance: X units should not be less than Y units
constraint
  x_units >= y_units;

% Tactical balance: Z units should not exceed Y units
constraint
  z_units <= y_units;

% Total cost definition (links decision variables to total_cost)
constraint
  total_cost = cost_X * x_units + cost_Y * y_units + cost_Z * z_units;

% Objective
solve minimize total_cost;

output [
  "x_units=", show(x_units), "\n",
  "y_units=", show(y_units), "\n",
  "z_units=", show(z_units), "\n",
  "total_cost=$", show(total_cost), "\n"
];