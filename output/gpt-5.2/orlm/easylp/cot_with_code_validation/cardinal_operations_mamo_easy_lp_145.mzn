% Parameters
int: max_weight = 10000;
int: weight_tank = 3;
int: weight_aircraft = 4;

int: min_firepower = 2000;
int: firepower_coeff_tank = 2;
int: firepower_coeff_aircraft = 1;

int: cost_tank = 5000;
int: cost_aircraft = 3000;

% Variables
var 0..(max_weight div weight_tank): tanks;
var 0..(max_weight div weight_aircraft): aircraft;

var 0..(cost_tank * (max_weight div weight_tank) + cost_aircraft * (max_weight div weight_aircraft)): total_cost;

% Constraints
constraint weight_tank * tanks + weight_aircraft * aircraft <= max_weight;

constraint firepower_coeff_tank * tanks + firepower_coeff_aircraft * aircraft >= min_firepower;

constraint total_cost = cost_tank * tanks + cost_aircraft * aircraft;

% Objective
solve minimize total_cost;