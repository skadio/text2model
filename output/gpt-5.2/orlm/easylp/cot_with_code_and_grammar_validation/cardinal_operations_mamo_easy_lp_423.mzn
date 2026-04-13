% Parameters
int: max_total_units = 5000;
int: min_steel_units = 1000;
int: min_aluminum_units = 2000;
int: cost_steel = 20;
int: cost_aluminum = 30;

% Variables
var 0..max_total_units: steel_units;
var 0..max_total_units: aluminum_units;
var int: total_cost;

% Constraints
constraint steel_units >= min_steel_units;
constraint aluminum_units >= min_aluminum_units;
constraint steel_units + aluminum_units <= max_total_units;

constraint total_cost = cost_steel * steel_units + cost_aluminum * aluminum_units;

% Objective
solve minimize total_cost;