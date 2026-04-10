% Parameters
int: demand = 1500;
int: cap_camel = 50;
int: time_camel = 12;
int: cap_truck = 150;
int: time_truck = 5;

% Upper bounds based on meeting demand with only one transport type
int: max_camel = demand div cap_camel; % 30
int: max_truck = demand div cap_truck; % 10

% Variables
var 0..max_camel: camels;
var 0..max_truck: trucks;
var 0..(max_camel * time_camel + max_truck * time_truck): total_hours;

% Constraints
constraint cap_camel * camels + cap_truck * trucks >= demand;
constraint camels > trucks;

constraint total_hours = time_camel * camels + time_truck * trucks;

% Objective
solve minimize total_hours;