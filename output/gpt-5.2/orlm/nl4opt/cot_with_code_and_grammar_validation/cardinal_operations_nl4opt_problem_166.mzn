% Parameters
int: taxi_capacity = 2;
int: car_capacity = 3;
int: min_employees = 500;
int: min_car_rides = 30;
int: max_car_fraction_num = 60; % percent numerator
int: max_car_fraction_den = 100; % percent denominator

% Variables
int: max_total_rides = ceil(min_employees / min(taxi_capacity, car_capacity)) + 1000;
var 0..max_total_rides: taxi_rides;
var 0..max_total_rides: car_rides;

% Constraints
constraint taxi_capacity * taxi_rides + car_capacity * car_rides >= min_employees;
constraint car_rides >= min_car_rides;

% At most 60% of rides are company car rides: car_rides / (taxi_rides + car_rides) <= 0.6
constraint max_car_fraction_den * car_rides <= max_car_fraction_num * (taxi_rides + car_rides);

% Objective
solve minimize taxi_rides;