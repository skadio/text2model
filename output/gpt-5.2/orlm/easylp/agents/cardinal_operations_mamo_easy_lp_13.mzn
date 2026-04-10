% Parameters
int: cost_solar = 4;                 % $ cost per unit of solar project
int: cost_wind  = 5;                 % $ cost per unit of wind project

int: solar_coeff = 3;                % MW contribution factor per solar unit (portfolio constraint)
int: wind_coeff  = 2;                % MW contribution factor per wind unit (portfolio constraint)
int: min_total_mw = 10;              % minimum required total MW

int: max_diff_mw = 5;                % maximum allowed absolute difference in outputs (MW)

% Upper bounds (safe bounds derived from constraints to keep variables bounded)
int: max_solar_units = 10;           % safely sufficient upper bound
int: max_wind_units  = 10;           % safely sufficient upper bound


% Variables
var 0..max_solar_units: solar_units; % number of solar units (integer, non-negative)
var 0..max_wind_units:  wind_units;  % number of wind units (integer, non-negative)

var 0..(cost_solar*max_solar_units + cost_wind*max_wind_units): total_cost; % total investment cost ($)


% Constraints
% Link total_cost to decision variables (solar_units, wind_units)
constraint
  total_cost = cost_solar * solar_units + cost_wind * wind_units;

% Minimum total MW requirement from the combined portfolio
constraint
  solar_coeff * solar_units + wind_coeff * wind_units >= min_total_mw;

% Balance constraint: absolute difference between solar and wind outputs is bounded
constraint
  abs(solar_coeff * solar_units - wind_coeff * wind_units) <= max_diff_mw;


% Objective
solve minimize total_cost;