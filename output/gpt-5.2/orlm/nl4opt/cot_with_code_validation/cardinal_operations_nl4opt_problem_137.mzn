% Parameters
int: cows_needed = 80;
int: heli_capacity = 3;
int: truck_capacity = 7;
int: heli_pollution = 5;
int: truck_pollution = 10;
int: max_truck_trips = 8;

% Variables
var 0..cows_needed: heli_trips;
var 0..max_truck_trips: truck_trips;
var 0..(heli_pollution * cows_needed + truck_pollution * max_truck_trips): total_pollution;

% Constraints
constraint heli_capacity * heli_trips + truck_capacity * truck_trips >= cows_needed;

constraint total_pollution = heli_pollution * heli_trips + truck_pollution * truck_trips;

% Objective
solve minimize total_pollution;