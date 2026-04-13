% Parameters
int: sub_capacity = 100;
int: boat_capacity = 80;

int: sub_gas = 30;
int: boat_gas = 25;

int: sub_max_trips = 6;
int: mail_required = 1000;

% Variables
var 0..sub_max_trips: sub_trips;
var 0..1000: boat_trips;

% Constraints
constraint sub_trips <= sub_max_trips;

constraint sub_capacity * sub_trips + boat_capacity * boat_trips >= mail_required;

% At least 50% of trips must be by boat: boat_trips >= (sub_trips + boat_trips)/2  <=> boat_trips >= sub_trips
constraint boat_trips >= sub_trips;

% Objective
solve minimize sub_gas * sub_trips + boat_gas * boat_trips;