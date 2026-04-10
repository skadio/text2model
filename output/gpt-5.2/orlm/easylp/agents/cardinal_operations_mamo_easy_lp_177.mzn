% Parameters
int: cost_solar   = 10;      % $ per unit Solar energy
int: cost_wind    = 15;      % $ per unit Wind energy
int: cost_nuclear = 20;      % $ per unit Nuclear energy

int: min_total_production   = 10000; % minimum combined production requirement
int: max_diff_solar_wind    = 5000;  % |Solar - Wind| must be <= this
int: min_nuclear_over_wind  = 2000;  % Nuclear must be at least this many units more than Wind


% Variables
var 0..min_total_production: solar_units;  % units produced by Solar (integer, nonnegative)
var 0..min_total_production: wind_units;   % units produced by Wind (integer, nonnegative)
var 0..(min_total_production + min_nuclear_over_wind): nuclear_units;
  % units produced by Nuclear (integer, nonnegative)

% Upper bound is a safe (loose) bound for the objective variable
var 0..(cost_nuclear * (min_total_production + min_nuclear_over_wind)
      + cost_wind * min_total_production
      + cost_solar * min_total_production): total_cost; % total investment cost in dollars


% Constraints

% Total production requirement: combined output must meet or exceed the target
constraint
  solar_units + wind_units + nuclear_units >= min_total_production;

% Environmental impact constraint: limit the absolute difference between Solar and Wind
constraint
  abs(solar_units - wind_units) <= max_diff_solar_wind;

% Strategic portfolio constraint: Nuclear must exceed Wind by at least the required margin
constraint
  nuclear_units >= wind_units + min_nuclear_over_wind;

% Total cost accounting: compute total investment cost from per-unit costs
constraint
  total_cost =
    cost_solar * solar_units +
    cost_wind * wind_units +
    cost_nuclear * nuclear_units;


% Objective
solve minimize total_cost;