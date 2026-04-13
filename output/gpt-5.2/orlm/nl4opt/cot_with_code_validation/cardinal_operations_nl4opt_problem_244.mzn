% Parameters
int: plane_capacity = 10;
int: truck_capacity = 6;
int: plane_cost = 1000;
int: truck_cost = 700;

int: min_tires = 200;
int: budget = 22000;

% Variables
var 0..ceil(int2float(budget) / int2float(plane_cost)): plane_trips;
var 0..ceil(int2float(budget) / int2float(truck_cost)): truck_trips;

% Constraints
constraint plane_capacity * plane_trips + truck_capacity * truck_trips >= min_tires;
constraint plane_cost * plane_trips + truck_cost * truck_trips <= budget;
constraint plane_trips <= truck_trips;

% Objective
solve minimize plane_trips + truck_trips;