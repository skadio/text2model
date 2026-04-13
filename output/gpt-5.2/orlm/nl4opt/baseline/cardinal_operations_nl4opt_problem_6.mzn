% Meal delivery vehicle mix optimization

int: bike_capacity = 8;
int: bike_charge   = 3;

int: scooter_capacity = 5;
int: scooter_charge   = 2;

int: total_charge = 200;

float: max_bike_fraction = 0.30; % at most 30% bikes
int: min_scooters = 20;

% Decision variables
var 0..total_charge div bike_charge: bikes;
var min_scooters..total_charge div scooter_charge: scooters;

% Charge constraint
constraint bike_charge * bikes + scooter_charge * scooters <= total_charge;

% At most 30% of vehicles are bikes: bikes <= 0.30 * (bikes + scooters)
% Use integer-safe form:
% bikes/(bikes+scooters) <= 3/10  => 10*bikes <= 3*(bikes+scooters)
constraint 10 * bikes <= 3 * (bikes + scooters);

% Objective: maximize meals delivered
var int: meals = bike_capacity * bikes + scooter_capacity * scooters;
solve maximize meals;

output [
  "bikes=", show(bikes), "\n",
  "scooters=", show(scooters), "\n",
  "meals=", show(meals), "\n",
  "charge_used=", show(bike_charge*bikes + scooter_charge*scooters), "\n"
];