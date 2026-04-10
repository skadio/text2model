% Parameters
int: bike_meals = 8;
int: scooter_meals = 5;

int: bike_charge = 3;
int: scooter_charge = 2;

int: total_charge = 200;

float: max_bike_fraction = 0.30;
int: min_scooters = 20;

% Variables
var 0..total_charge div bike_charge: bikes;
var min_scooters..total_charge div scooter_charge: scooters;

var 0..(bike_meals * (total_charge div bike_charge) + scooter_meals * (total_charge div scooter_charge)): total_meals;

% Constraints
constraint bike_charge * bikes + scooter_charge * scooters <= total_charge;

% At most 30% of vehicles are bikes: bikes <= 0.30*(bikes+scooters)
% Use integer form to avoid floats: 10*bikes <= 3*(bikes+scooters)  <=> 7*bikes <= 3*scooters
constraint 7 * bikes <= 3 * scooters;

constraint total_meals = bike_meals * bikes + scooter_meals * scooters;

% Objective
solve maximize total_meals;