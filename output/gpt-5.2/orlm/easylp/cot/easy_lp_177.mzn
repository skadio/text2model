% Parameters (with values embedded)
int: cost_solar = 10;
int: cost_wind = 15;
int: cost_nuclear = 20;

int: min_total_production = 10000;
int: max_abs_diff_solar_wind = 5000;
int: nuclear_minus_wind_min = 2000;

% Variable bounds (derived from requirements and non-negativity)
int: ub = min_total_production + max_abs_diff_solar_wind + nuclear_minus_wind_min; % safe upper bound

% Variables
var 0..ub: Solar;
var 0..ub: Wind;
var 0..ub: Nuclear;

var int: TotalCost;

% Constraints
constraint Solar + Wind + Nuclear >= min_total_production;
constraint abs(Solar - Wind) <= max_abs_diff_solar_wind;
constraint Nuclear >= Wind + nuclear_minus_wind_min;

constraint TotalCost = cost_solar * Solar + cost_wind * Wind + cost_nuclear * Nuclear;

% Objective
solve minimize TotalCost;