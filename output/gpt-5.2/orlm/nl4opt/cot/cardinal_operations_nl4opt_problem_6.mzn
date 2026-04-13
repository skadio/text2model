% Parameters (with values embedded)
int: bike_meals = 8;
int: bike_charge = 3;
int: scooter_meals = 5;
int: scooter_charge = 2;

int: total_charge = 200;

float: max_bike_ratio = 0.30;   % at most 30% of vehicles are bikes
int: min_scooters = 20;

% Variables
var 0..total_charge: bikes;
var 0..total_charge: scooters;
var 0..(bike_meals * total_charge): total_meals;

% Constraints
constraint total_meals = bike_meals * bikes + scooter_meals * scooters;

constraint bike_charge * bikes + scooter_charge * scooters <= total_charge;

constraint scooters >= min_scooters;

% At most 30% bikes: bikes <= 0.30 * (bikes + scooters)
% Avoid floats by multiplying: 10*bikes <= 3*(bikes + scooters)  => 7*bikes <= 3*scooters
constraint 7 * bikes <= 3 * scooters;

% Objective
solve maximize total_meals;