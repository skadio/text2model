% Parameters
int: max_total_units = 10000;              % Maximum total number of units deployable
int: min_effectiveness = 20000;            % Minimum required combined effectiveness

int: eff_X = 5;                            % Effectiveness per unit of type X
int: eff_Y = 3;                            % Effectiveness per unit of type Y
int: eff_Z = 7;                            % Effectiveness per unit of type Z

int: cost_X = 500;                         % Cost per unit of type X (dollars)
int: cost_Y = 300;                         % Cost per unit of type Y (dollars)
int: cost_Z = 700;                         % Cost per unit of type Z (dollars)

% Variables
var 0..max_total_units: units_X;           % Number of X units deployed (non-negative integer)
var 0..max_total_units: units_Y;           % Number of Y units deployed (non-negative integer)
var 0..max_total_units: units_Z;           % Number of Z units deployed (non-negative integer)

var 0..max_total_units: total_units;       % Total deployed units
var 0..(eff_X*max_total_units + eff_Y*max_total_units + eff_Z*max_total_units): total_effectiveness; % Total effectiveness
var 0..(cost_X*max_total_units + cost_Y*max_total_units + cost_Z*max_total_units): total_cost;       % Total cost (dollars)

% Constraints
% Link aggregate variables to unit decisions
constraint total_units = units_X + units_Y + units_Z;

constraint
  total_effectiveness =
    eff_X * units_X + eff_Y * units_Y + eff_Z * units_Z;

constraint
  total_cost =
    cost_X * units_X + cost_Y * units_Y + cost_Z * units_Z;

% Logistical constraint: total units cannot exceed the maximum allowed
constraint total_units <= max_total_units;

% Strategic constraint: achieve at least the minimum required effectiveness
constraint total_effectiveness >= min_effectiveness;

% Tactical constraints: relative quantities between unit types
constraint units_X >= units_Y;
constraint units_Z <= units_Y;

% Objective
solve minimize total_cost;