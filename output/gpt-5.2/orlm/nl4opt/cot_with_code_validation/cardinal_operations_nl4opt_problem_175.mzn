% Parameters
int: van_capacity = 50;
int: truck_capacity = 80;
int: van_cost = 30;
int: truck_cost = 50;
int: min_boxes = 1500;
int: budget = 1000;

% Variables
var 0..(budget div van_cost): van_trips;
var 0..(budget div truck_cost): truck_trips;

% Constraints
constraint van_capacity * van_trips + truck_capacity * truck_trips >= min_boxes;
constraint van_cost * van_trips + truck_cost * truck_trips <= budget;
constraint van_trips > truck_trips;

% Objective
solve minimize van_trips + truck_trips;