% Parameters
int: cost_raw = 5;
int: cost_labor = 10;

int: min_quality = 20;          % 2*raw + 3*labor >= 20
int: max_diff = 30;             % |raw - labor| <= 30
int: total_units = 100;         % raw + labor = 100

% Variables
var 0..total_units: raw;
var 0..total_units: labor;
var 0..(cost_raw*total_units + cost_labor*total_units): total_cost;

% Constraints
constraint raw + labor = total_units;

constraint 2*raw + 3*labor >= min_quality;

constraint abs(raw - labor) <= max_diff;

constraint total_cost = cost_raw*raw + cost_labor*labor;

% Objective
solve minimize total_cost;