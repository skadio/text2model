% Parameters
% Unit investment costs ($M per unit)
int: cost_solar   = 5;
int: cost_wind    = 10;
int: cost_hydro   = 20;
int: cost_nuclear = 30;

% Strategic / regulatory constraint parameters
int: min_solar_wind = 2000;             % solar + wind must be at least this
int: max_hydro_nuclear = 5000;          % hydro + nuclear must be at most this
int: max_diff_solar_wind = 1000;        % |solar - wind| <= this
int: min_hydro_minus_nuclear = 500;     % hydro >= nuclear + this

% Practical bounds
int: max_solar = 3000;
int: max_wind  = 2500;
int: min_hydro = 1000;
int: max_hydro = 4000;
int: min_nuclear = 1500;
int: max_nuclear = 3500;

% Variables
% Integer (whole unit) investment decisions
var 0..max_solar: solar;
var 0..max_wind: wind;
var min_hydro..max_hydro: hydro;
var min_nuclear..max_nuclear: nuclear;

% Total cost in $M
var int: total_cost;

% Constraints
% --- Portfolio size constraints ---
constraint solar + wind >= min_solar_wind;
constraint hydro + nuclear <= max_hydro_nuclear;

% --- Balance / relationship constraints ---
constraint abs(solar - wind) <= max_diff_solar_wind;
constraint hydro >= nuclear + min_hydro_minus_nuclear;

% --- Cost aggregation constraint ---
constraint total_cost =
    cost_solar * solar
  + cost_wind * wind
  + cost_hydro * hydro
  + cost_nuclear * nuclear;

% Objective
solve minimize total_cost;