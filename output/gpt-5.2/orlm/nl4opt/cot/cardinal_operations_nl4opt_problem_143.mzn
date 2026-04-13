% Parameters (with values embedded)
int: demand = 1500;
int: camel_capacity = 50;
int: camel_time = 12;
int: truck_capacity = 150;
int: truck_time = 5;

% Variables
var 0..(demand div camel_capacity): camels;
var 0..(demand div truck_capacity): trucks;

% Constraints
constraint camel_capacity * camels + truck_capacity * trucks >= demand;
constraint camels > trucks;

% Objective
solve minimize camel_time * camels + truck_time * trucks;