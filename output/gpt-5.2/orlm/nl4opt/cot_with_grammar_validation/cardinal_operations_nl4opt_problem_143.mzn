% Parameters
int: demand = 1500;
int: cap_camel = 50;
int: cap_truck = 150;
int: time_camel = 12;
int: time_truck = 5;

% Variables
var 0..(demand div cap_camel): camels;
var 0..(demand div cap_truck): trucks;
var 0..(time_camel*(demand div cap_camel) + time_truck*(demand div cap_truck)): total_hours;

% Constraints
constraint cap_camel * camels + cap_truck * trucks >= demand;
constraint camels > trucks;

constraint total_hours = time_camel * camels + time_truck * trucks;

% Objective
solve minimize total_hours;