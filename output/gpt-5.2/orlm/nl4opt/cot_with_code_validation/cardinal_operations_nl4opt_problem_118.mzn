% Parameters
int: heli_capacity = 30;
int: heli_time = 40;
int: car_capacity = 20;
int: car_time = 30;

int: max_heli_trips = 5;
int: min_car_trip_percent = 60; % percent
int: min_fish = 300;

% Variables
var 0..max_heli_trips: heli_trips;
var 0..15: car_trips; % upper bound sufficient for feasibility/optimality

var 0..(max_heli_trips*heli_capacity + 15*car_capacity): total_fish;
var 0..(max_heli_trips + 15): total_trips;
var 0..(max_heli_trips*heli_time + 15*car_time): total_time;

% Constraints
constraint total_fish = heli_capacity * heli_trips + car_capacity * car_trips;
constraint total_trips = heli_trips + car_trips;
constraint total_time = heli_time * heli_trips + car_time * car_trips;

constraint total_fish >= min_fish;

% At least 60% of trips are by car: car_trips / total_trips >= 0.6
% Avoid division: 100*car_trips >= 60*total_trips
constraint 100 * car_trips >= min_car_trip_percent * total_trips;

% Ensure denominator not zero (also implied by min_fish, but stated explicitly)
constraint total_trips >= 1;

% Objective
solve minimize total_time;