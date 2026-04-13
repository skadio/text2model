% Parameters
% Capacity (fish) and time (minutes) per trip type
int: heli_capacity = 30;
int: heli_time = 40;

int: car_capacity = 20;
int: car_time = 30;

% Policy limits
int: max_heli_trips = 5;          % at most 5 helicopter trips
int: min_car_trip_pct = 60;       % at least 60% of trips are by car (percentage)

% Demand
int: min_fish = 300;              % at least 300 fish must be transported

% Derived bounds for decision variables (simple safe upper bounds)
% With max_heli_trips fixed, at least (min_fish - max_heli_trips*heli_capacity) fish remain for cars (if positive).
int: min_car_fish_needed = max(0, min_fish - max_heli_trips * heli_capacity);
int: max_car_trips = (min_fish div car_capacity) + 20; % safe upper bound

% Variables
var 0..max_heli_trips: heli_trips;   % number of helicopter trips
var 0..max_car_trips: car_trips;     % number of car trips

var 0..(max_heli_trips*heli_capacity + max_car_trips*car_capacity): total_fish; % total fish moved
var 0..(max_heli_trips*heli_time + max_car_trips*car_time): total_time;         % total time (minutes)

% Constraints

% --- Total fish and time accounting ---
constraint total_fish =
    heli_trips * heli_capacity + car_trips * car_capacity;

constraint total_time =
    heli_trips * heli_time + car_trips * car_time;

% --- Demand satisfaction (move at least the required number of fish) ---
constraint total_fish >= min_fish;

% --- Helicopter trip policy limit (already bounded by var domain, restated for clarity) ---
constraint heli_trips <= max_heli_trips;

% --- Minimum percentage of trips by car (at least min_car_trip_pct%) ---
% car_trips / (heli_trips + car_trips) >= min_car_trip_pct/100
% Cross-multiplied to avoid fractions:
constraint 100 * car_trips >= min_car_trip_pct * (heli_trips + car_trips);

% --- Optional strengthening: if helicopters are maxed out, cars must cover remaining fish (safe lower bound) ---
% This is implied by total_fish >= min_fish, but can help propagation.
constraint car_trips * car_capacity >= min_car_fish_needed;

% Objective
solve minimize total_time;