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

% Constraints
constraint heli_capacity * heli_trips + truck_capacity * truck_trips >= cows_needed;

% Objective
solve minimize heli_pollution * heli_trips + truck_pollution * truck_trips;