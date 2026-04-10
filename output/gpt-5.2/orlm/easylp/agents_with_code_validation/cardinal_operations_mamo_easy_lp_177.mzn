% Parameters
int: cost_solar   = 10;     % $ per unit of Solar energy
int: cost_wind    = 15;     % $ per unit of Wind energy
int: cost_nuclear = 20;     % $ per unit of Nuclear energy

int: min_total_production  = 10000; % minimum combined production (units)
int: max_diff_solar_wind   = 5000;  % |Solar - Wind| must be <= this
int: min_nuclear_over_wind = 2000;  % Nuclear must be at least this many units more than Wind


% Variables
var 0..min_total_production: solar_units;    % Solar energy units (integer, nonnegative)
var 0..min_total_production: wind_units;     % Wind energy units (integer, nonnegative)
var 0..min_total_production: nuclear_units;  % Nuclear energy units (integer, nonnegative)

% Upper bound: worst-case all production at max units with respective costs
var 0..(cost_solar*min_total_production
      + cost_wind*min_total_production
      + cost_nuclear*min_total_production): total_cost; % total investment cost ($)


% Constraints
% Total production must meet or exceed the policy target
constraint solar_units + wind_units + nuclear_units >= min_total_production;

% Solar and Wind difference limited for environmental impact considerations
constraint abs(solar_units - wind_units) <= max_diff_solar_wind;

% Balanced portfolio: Nuclear must exceed Wind by at least the required margin
constraint nuclear_units >= wind_units + min_nuclear_over_wind;

% Define total investment cost from unit costs and productions
constraint total_cost = cost_solar * solar_units
                      + cost_wind * wind_units
                      + cost_nuclear * nuclear_units;


% Objective
solve minimize total_cost;