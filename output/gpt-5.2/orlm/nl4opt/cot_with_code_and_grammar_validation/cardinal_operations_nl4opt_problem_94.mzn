% Parameters
int: ferry_capacity = 20;
int: rail_capacity = 15;
int: min_boxes = 500;
int: rail_to_ferry_ratio = 4;

% Variables
var 0..ceil(min_boxes / min(ferry_capacity, rail_capacity)): ferry_trips;
var 0..ceil(min_boxes / min(ferry_capacity, rail_capacity)): rail_trips;

% Constraints
constraint rail_trips >= rail_to_ferry_ratio * ferry_trips;

constraint ferry_capacity * ferry_trips + rail_capacity * rail_trips >= min_boxes;

% Objective
solve minimize ferry_trips + rail_trips;