% Parameters
% Investment cost per unit (in million $)
int: cost_solar   = 5;
int: cost_wind    = 10;
int: cost_hydro   = 20;
int: cost_nuclear = 30;

% Strategic/regulatory requirements
int: min_solar_wind = 2000;          % solar + wind >= 2000
int: max_hydro_nuclear = 5000;       % hydro + nuclear <= 5000
int: max_diff_solar_wind = 1000;     % |solar - wind| <= 1000
int: min_hydro_over_nuclear = 500;   % hydro >= nuclear + 500

% Practical bounds (units)
int: solar_ub = 3000;
int: wind_ub  = 2500;
int: hydro_lb = 1000;
int: hydro_ub = 4000;
int: nuclear_lb = 1500;
int: nuclear_ub = 3500;

% Variables
var 0..solar_ub: solar_units;                 % number of solar plant units
var 0..wind_ub: wind_units;                   % number of wind plant units
var hydro_lb..hydro_ub: hydro_units;          % number of hydro plant units
var nuclear_lb..nuclear_ub: nuclear_units;    % number of nuclear plant units

var int: total_cost_million;                  % total cost (million $)

% Constraints
% Strategic/regulatory: minimum combined solar and wind investment
constraint solar_units + wind_units >= min_solar_wind;

% Strategic/regulatory: maximum combined hydro and nuclear investment
constraint hydro_units + nuclear_units <= max_hydro_nuclear;

% Balanced portfolio: solar and wind investments must be close (absolute difference bound)
constraint abs(solar_units - wind_units) <= max_diff_solar_wind;

% Portfolio relationship: hydro must exceed nuclear by at least the required margin
constraint hydro_units >= nuclear_units + min_hydro_over_nuclear;

% Total cost calculation (in million $)
constraint total_cost_million =
  cost_solar * solar_units +
  cost_wind * wind_units +
  cost_hydro * hydro_units +
  cost_nuclear * nuclear_units;

% Objective
solve minimize total_cost_million;