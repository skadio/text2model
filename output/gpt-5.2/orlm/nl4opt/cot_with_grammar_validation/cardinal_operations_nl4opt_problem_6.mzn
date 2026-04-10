% Parameters
int: bike_capacity = 8;
int: bike_charge = 3;
int: scooter_capacity = 5;
int: scooter_charge = 2;

float: max_bike_fraction = 0.30;
int: min_scooters = 20;
int: total_charge = 200;

% Variables
var 0..(total_charge div bike_charge): bikes;
var 0..(total_charge div scooter_charge): scooters;

% Constraints
constraint bike_charge * bikes + scooter_charge * scooters <= total_charge;

constraint scooters >= min_scooters;

% bikes <= 0.30*(bikes+scooters)  <=>  0.70*bikes <= 0.30*scooters  <=>  7*bikes <= 3*scooters
constraint 7 * bikes <= 3 * scooters;

% Objective
solve maximize bike_capacity * bikes + scooter_capacity * scooters;