% Parameters
int: max_weight = 10000;
int: tank_weight = 3;
int: aircraft_weight = 4;

int: min_firepower = 2000;
int: tank_firepower_coeff = 2;
int: aircraft_firepower_coeff = 1;

int: tank_cost = 5000;
int: aircraft_cost = 3000;

% Variables
var 0..(max_weight div tank_weight): tanks;
var 0..(max_weight div aircraft_weight): aircraft;

var 0..(tank_cost*(max_weight div tank_weight) + aircraft_cost*(max_weight div aircraft_weight)): total_cost;

% Constraints
constraint tank_weight * tanks + aircraft_weight * aircraft <= max_weight;

constraint tank_firepower_coeff * tanks + aircraft_firepower_coeff * aircraft >= min_firepower;

constraint total_cost = tank_cost * tanks + aircraft_cost * aircraft;

% Objective
solve minimize total_cost;