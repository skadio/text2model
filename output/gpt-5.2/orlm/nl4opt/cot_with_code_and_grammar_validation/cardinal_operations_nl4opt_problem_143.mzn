% Parameters
int: demand = 1500;
int: camel_capacity = 50;
int: truck_capacity = 150;
int: camel_time = 12;
int: truck_time = 5;

% Variables
var 0..(demand div camel_capacity): camels;
var 0..(demand div truck_capacity): trucks;
var 0..(camel_time * (demand div camel_capacity) + truck_time * (demand div truck_capacity)): total_hours;

% Constraints
constraint camel_capacity * camels + truck_capacity * trucks >= demand;
constraint camels > trucks;
constraint total_hours = camel_time * camels + truck_time * trucks;

% Objective
solve minimize total_hours;