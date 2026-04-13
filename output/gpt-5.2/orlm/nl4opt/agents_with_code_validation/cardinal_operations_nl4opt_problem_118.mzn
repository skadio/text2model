% Parameters
int: heli_capacity = 30;          % fish per helicopter trip
int: heli_time = 40;              % minutes per helicopter trip
int: car_capacity = 20;           % fish per car trip
int: car_time = 30;               % minutes per car trip

int: max_heli_trips = 5;          % at most this many helicopter trips
int: min_fish = 300;              % at least this many fish must be transported
int: min_car_trip_percent = 60;   % at least 60% of trips should be by car


% Variables
var 0..max_heli_trips: heli_trips;   % number of helicopter trips
var 0..15: car_trips;                % number of car trips (sufficient upper bound)

var 0..20: total_trips;              % total number of trips (<= 5 + 15)
var 0..450: total_fish;              % total fish transported (<= 30*5 + 20*15)
var 0..650: total_time;              % total time in minutes (<= 40*5 + 30*15)


% Constraints
% --- Derived totals ---
constraint total_trips = heli_trips + car_trips;
constraint total_fish  = heli_capacity * heli_trips + car_capacity * car_trips;
constraint total_time  = heli_time * heli_trips + car_time * car_trips;

% --- Capacity / requirement constraints ---
constraint total_fish >= min_fish;

% --- Trip composition constraints ---
% Ensure at least one trip occurs (avoid degenerate percentage constraint)
constraint total_trips >= 1;

% At least min_car_trip_percent% of all trips are by car:
% car_trips / total_trips >= min_car_trip_percent/100
constraint 100 * car_trips >= min_car_trip_percent * total_trips;

% --- Helicopter usage limit (also implied by domain) ---
constraint heli_trips <= max_heli_trips;


% Objective
solve minimize total_time;