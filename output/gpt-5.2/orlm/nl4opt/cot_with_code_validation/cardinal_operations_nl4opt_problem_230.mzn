% Parameters
int: container_capacity = 30;
int: truck_capacity = 40;
int: min_oil = 2000;
int: min_containers = 15;

% Variables
var 0..ceil(min_oil / container_capacity): containers;
var 0..ceil(min_oil / truck_capacity): trucks;

% Constraints
constraint containers >= min_containers;

constraint container_capacity * containers + truck_capacity * trucks >= min_oil;

constraint trucks * 2 <= containers;

% Objective
solve minimize containers + trucks;