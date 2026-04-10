% Parameters
int: sub_capacity = 100;
int: boat_capacity = 80;
int: sub_gas = 30;
int: boat_gas = 25;

int: max_sub_trips = 6;
int: min_mail = 1000;

% Variables
var 0..max_sub_trips: sub_trips;
var 0..20: boat_trips; % safe upper bound for feasibility (see constraints)

% Constraints
constraint sub_trips <= max_sub_trips;

constraint sub_trips * sub_capacity + boat_trips * boat_capacity >= min_mail;

% At least 50% of trips must be by boat: boat_trips >= sub_trips
constraint boat_trips >= sub_trips;

% Tighten boat_trips bound to avoid unnecessary search
constraint boat_trips <= ceil(min_mail div boat_capacity) + 1;

% Objective
solve minimize sub_trips * sub_gas + boat_trips * boat_gas;