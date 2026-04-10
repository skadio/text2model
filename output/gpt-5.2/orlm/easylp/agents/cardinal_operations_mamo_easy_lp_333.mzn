% Parameters
% Costs per unit (in dollars) for each source
float: cost_coal  = 0.8;
float: cost_gas   = 1.2;
float: cost_wind  = 1.0;
float: cost_solar = 1.5;

% Minimum combined production requirements (units)
int: min_coal_gas   = 500;
int: min_wind_solar = 200;

% Maximum production capacities per day (units)
int: max_coal  = 700;
int: max_gas   = 600;
int: max_wind  = 300;
int: max_solar = 250;

% Variables
% Daily units generated from each source (whole numbers)
var 0..max_coal:  units_coal;
var 0..max_gas:   units_gas;
var 0..max_wind:  units_wind;
var 0..max_solar: units_solar;

% Total cost (in dollars)
var float: total_cost;

% Constraints
% Meet minimum combined production requirements
constraint units_coal + units_gas >= min_coal_gas;
constraint units_wind + units_solar >= min_wind_solar;

% Define total cost from per-source generation and unit costs
constraint
  total_cost =
      cost_coal  * int2float(units_coal) +
      cost_gas   * int2float(units_gas) +
      cost_wind  * int2float(units_wind) +
      cost_solar * int2float(units_solar);

% Objective
solve minimize total_cost;