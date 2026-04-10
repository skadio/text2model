% Parameters
% Unit costs ($ per unit) for each generation source (embedded data)
int: cost_coal  = 8;   % 0.8 dollars represented as tenths
int: cost_gas   = 12;  % 1.2 dollars represented as tenths
int: cost_wind  = 10;  % 1.0 dollars represented as tenths
int: cost_solar = 15;  % 1.5 dollars represented as tenths

% Minimum combined generation requirements (units)
int: min_coal_gas   = 500;
int: min_wind_solar = 200;

% Maximum generation capacities (units)
int: max_coal  = 700;
int: max_gas   = 600;
int: max_wind  = 300;
int: max_solar = 250;


% Variables
% Decision variables: integer units generated per day from each source
var 0..max_coal:  units_coal;
var 0..max_gas:   units_gas;
var 0..max_wind:  units_wind;
var 0..max_solar: units_solar;

% Total cost in tenths of dollars (to keep everything integer)
var 0..(cost_coal*max_coal + cost_gas*max_gas + cost_wind*max_wind + cost_solar*max_solar): total_cost_tenths;

% Total cost in dollars rounded to nearest whole number
var 0..((cost_coal*max_coal + cost_gas*max_gas + cost_wind*max_wind + cost_solar*max_solar + 5) div 10): total_cost_rounded_dollars;


% Constraints
% Link total cost (in tenths of dollars) to generation decisions
constraint
  total_cost_tenths =
    cost_coal  * units_coal +
    cost_gas   * units_gas +
    cost_wind  * units_wind +
    cost_solar * units_solar;

% Minimum combined generation requirement for coal + gas
constraint
  units_coal + units_gas >= min_coal_gas;

% Minimum combined generation requirement for wind + solar
constraint
  units_wind + units_solar >= min_wind_solar;

% Compute rounded total cost in whole dollars (nearest dollar)
% Since total_cost_tenths is in tenths of dollars, rounding is (x + 5) div 10
constraint
  total_cost_rounded_dollars = (total_cost_tenths + 5) div 10;


% Objective
solve minimize total_cost_tenths;