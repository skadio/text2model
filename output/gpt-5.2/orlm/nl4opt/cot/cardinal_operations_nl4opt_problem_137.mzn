% Parameters (with values embedded)
int: cows_needed = 80;
int: heli_capacity = 3;
int: truck_capacity = 7;
int: heli_pollution = 5;
int: truck_pollution = 10;
int: max_truck_trips = 8;

% Variables
var 0..cows_needed: h;                 % number of helicopter trips
var 0..max_truck_trips: t;             % number of truck trips

% Constraints
constraint heli_capacity * h + truck_capacity * t >= cows_needed;

% Objective
solve minimize heli_pollution * h + truck_pollution * t;