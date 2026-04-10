% Parameters
int: cost_solar = 4;                 % $ per unit of solar project
int: cost_wind  = 5;                 % $ per unit of wind project

int: coeff_solar = 3;                % MW contribution coefficient for solar in balance constraint
int: coeff_wind  = 2;                % MW contribution coefficient for wind in balance constraint
int: min_total_power = 10;           % Minimum required total power (MW)

int: max_power_diff = 5;             % Maximum allowed difference between solar and wind outputs (MW)

% Variable bounds (kept explicit and finite for MiniZinc)
int: max_units = 100;                % Safe upper bound on units to keep domains finite


% Variables
var 0..max_units: solar_units;       % Number of solar project units (integer, nonnegative)
var 0..max_units: wind_units;        % Number of wind project units (integer, nonnegative)

var 0..(cost_solar*max_units + cost_wind*max_units): total_cost;  % Total investment cost ($)

% Helper: absolute difference between solar and wind project units
var 0..max_power_diff: power_diff_abs;


% Constraints

% Link total investment cost to chosen project units
constraint
  total_cost = cost_solar * solar_units + cost_wind * wind_units;

% Balanced portfolio: combined power from solar and wind must meet minimum requirement
constraint
  coeff_solar * solar_units + coeff_wind * wind_units >= min_total_power;

% Resource constraint: absolute difference between solar and wind outputs cannot exceed limit
constraint
  power_diff_abs = abs(solar_units - wind_units);

constraint
  power_diff_abs <= max_power_diff;


% Objective
solve minimize total_cost;