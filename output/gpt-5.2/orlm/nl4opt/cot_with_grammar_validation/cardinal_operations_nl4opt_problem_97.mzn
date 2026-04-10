% Parameters
int: truck_capacity = 50;
int: car_capacity = 30;
int: truck_gas = 20;
int: car_gas = 15;

int: max_truck_trips = 5;
int: min_packages = 500;

% Variables
var 0..max_truck_trips: truck_trips;
var 0..ceil(int2float(min_packages) / int2float(car_capacity)): car_trips;

var 0..(max_truck_trips + ceil(int2float(min_packages) / int2float(car_capacity))): total_trips;
var 0..(truck_capacity * max_truck_trips + car_capacity * ceil(int2float(min_packages) / int2float(car_capacity))): total_packages;
var 0..(truck_gas * max_truck_trips + car_gas * ceil(int2float(min_packages) / int2float(car_capacity))): total_gas;

% Constraints
constraint total_trips = truck_trips + car_trips;

constraint total_packages = truck_capacity * truck_trips + car_capacity * car_trips;
constraint total_packages >= min_packages;

% At least 30% of all trips are by car: car_trips / total_trips >= 0.30
% Linearized: 10 * car_trips >= 3 * total_trips, and total_trips >= 1 to avoid 0/0
constraint total_trips >= 1;
constraint 10 * car_trips >= 3 * total_trips;

constraint total_gas = truck_gas * truck_trips + car_gas * car_trips;

% Objective
solve minimize total_gas;