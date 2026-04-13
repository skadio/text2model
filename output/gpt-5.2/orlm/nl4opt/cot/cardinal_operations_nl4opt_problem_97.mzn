% Parameters (with values embedded)
int: truck_capacity = 50;
int: car_capacity = 30;
int: truck_gas = 20;
int: car_gas = 15;

int: max_truck_trips = 5;
float: min_car_fraction = 0.30;

int: min_packages = 500;

% Variables
var 0..max_truck_trips: truck_trips;
var 0..100: car_trips; % safe upper bound (see constraints)

% Constraints
constraint truck_trips <= max_truck_trips;

% At least 30% of all trips are by car: car_trips / (truck_trips + car_trips) >= 0.30
% Equivalent linear form: 7*car_trips >= 3*truck_trips (since 0.30 = 3/10)
constraint 7 * car_trips >= 3 * truck_trips;

% Must transport at least 500 packages
constraint truck_capacity * truck_trips + car_capacity * car_trips >= min_packages;

% Additional bound tightening for car_trips (implied by meeting package demand with nonnegative trips)
constraint car_trips <= ceil(int2float(min_packages) / int2float(car_capacity));

% Objective
var int: total_gas = truck_gas * truck_trips + car_gas * car_trips;

solve minimize total_gas;