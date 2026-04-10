% Parameters
int: truck_capacity = 50;
int: car_capacity = 30;
int: truck_gas = 20;
int: car_gas = 15;

int: max_truck_trips = 5;
int: min_packages = 500;

int: car_min_pct = 30; % percent

% Variables
var 0..max_truck_trips: truck_trips;
var 0..1000: car_trips;
var 0..1005: total_trips;
var 0..100000: total_gas;

% Constraints
constraint total_trips = truck_trips + car_trips;

constraint truck_capacity * truck_trips + car_capacity * car_trips >= min_packages;

% At least 30% of trips by car: car_trips / total_trips >= 0.30
% Avoid division: 100*car_trips >= 30*total_trips
constraint 100 * car_trips >= car_min_pct * total_trips;

constraint total_gas = truck_gas * truck_trips + car_gas * car_trips;

% Objective
solve minimize total_gas;