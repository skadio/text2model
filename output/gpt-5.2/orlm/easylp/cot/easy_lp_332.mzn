% Parameters (with values embedded)
int: cost_solar   = 5;   % million $ per unit
int: cost_wind    = 10;  % million $ per unit
int: cost_hydro   = 20;  % million $ per unit
int: cost_nuclear = 30;  % million $ per unit

int: min_solar_wind = 2000;
int: max_hydro_nuclear = 5000;
int: max_diff_solar_wind = 1000;
int: hydro_at_least_nuclear_plus = 500;

int: solar_ub = 3000;
int: wind_ub = 2500;
int: hydro_lb = 1000;
int: hydro_ub = 4000;
int: nuclear_lb = 1500;
int: nuclear_ub = 3500;

% Variables
var 0..solar_ub: solar;
var 0..wind_ub: wind;
var hydro_lb..hydro_ub: hydro;
var nuclear_lb..nuclear_ub: nuclear;

var int: total_cost;

% Constraints
constraint solar + wind >= min_solar_wind;
constraint hydro + nuclear <= max_hydro_nuclear;

constraint abs(solar - wind) <= max_diff_solar_wind;

constraint hydro >= nuclear + hydro_at_least_nuclear_plus;

constraint total_cost =
  cost_solar * solar +
  cost_wind * wind +
  cost_hydro * hydro +
  cost_nuclear * nuclear;

% Objective
solve minimize total_cost;