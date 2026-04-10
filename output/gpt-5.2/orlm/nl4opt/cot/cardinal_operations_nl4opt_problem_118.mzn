% Parameters (with values embedded)
int: min_fish = 300;

int: heli_capacity = 30;
int: car_capacity  = 20;

int: heli_time = 40; % minutes per trip
int: car_time  = 30; % minutes per trip

int: max_heli_trips = 5;

int: car_percent = 60; % at least 60% of trips are by car

% Variables
var 0..max_heli_trips: h;          % number of helicopter trips
var 0..50: c;                      % number of car trips (upper bound chosen safely)

var 0..1000: total_trips;
var 0..100000: total_fish;
var 0..1000000: total_time;

% Constraints
constraint total_trips = h + c;
constraint total_fish = heli_capacity * h + car_capacity * c;
constraint total_time = heli_time * h + car_time * c;

constraint total_fish >= min_fish;

% At least 60% of the trips are by car: c / (h+c) >= 0.6
% Avoid division: 100*c >= 60*(h+c)
constraint 100 * c >= car_percent * total_trips;

% If there are any trips, ensure denominator is nonzero (implied by needing >=300 fish)
constraint total_trips >= 1;

% Objective
solve minimize total_time;