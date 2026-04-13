% Parameters
int: sub_capacity = 100;
int: sub_gas = 30;
int: boat_capacity = 80;
int: boat_gas = 25;

int: max_sub_trips = 6;
int: min_mail = 1000;

% Variables
var 0..max_sub_trips: sub_trips;
var 0..100: boat_trips;

% Constraints
constraint sub_capacity * sub_trips + boat_capacity * boat_trips >= min_mail;

% At least 50% of trips must be by boat: boat_trips >= sub_trips
constraint boat_trips >= sub_trips;

% Objective
solve minimize sub_gas * sub_trips + boat_gas * boat_trips;