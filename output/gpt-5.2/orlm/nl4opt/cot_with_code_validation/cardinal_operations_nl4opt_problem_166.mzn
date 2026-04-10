% Parameters
int: taxi_capacity = 2;
int: car_capacity  = 3;
int: min_employees = 500;
int: min_car_rides = 30;
int: car_ride_pct_max_num = 60; % percent numerator
int: car_ride_pct_max_den = 100; % percent denominator

% Variables
var 0..10000: taxi_rides;
var min_car_rides..10000: car_rides;

% Constraints
constraint
  taxi_capacity * taxi_rides + car_capacity * car_rides >= min_employees;

constraint
  car_ride_pct_max_den * car_rides <= car_ride_pct_max_num * (taxi_rides + car_rides);

% Objective
solve minimize taxi_rides;