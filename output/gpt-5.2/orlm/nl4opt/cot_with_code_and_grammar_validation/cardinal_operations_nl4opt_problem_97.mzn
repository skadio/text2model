% Parameters
int: truck_capacity = 50;
int: car_capacity = 30;
int: truck_gas = 20;
int: car_gas = 15;
int: max_truck_trips = 5;
int: min_packages = 500;

% Variables
var 0..max_truck_trips: truck_trips;
var 0..1000: car_trips; % safe upper bound (can be tightened by constraints)

% Constraints
constraint truck_capacity * truck_trips + car_capacity * car_trips >= min_packages;

% At least 30% of all trips are by car:
% car_trips / (car_trips + truck_trips) >= 0.3  <=>  10*car_trips >= 3*(car_trips + truck_trips)
constraint 10 * car_trips >= 3 * (car_trips + truck_trips);

% Objective
solve minimize truck_gas * truck_trips + car_gas * car_trips;