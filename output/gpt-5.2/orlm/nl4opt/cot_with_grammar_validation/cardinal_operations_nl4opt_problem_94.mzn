% Parameters
int: ferry_capacity = 20;
int: rail_capacity  = 15;
int: min_boxes      = 500;
int: rail_to_ferry_ratio = 4;

% Variables
var 0..ceil(min_boxes div ferry_capacity) + ceil(min_boxes div rail_capacity): ferry_trips;
var 0..ceil(min_boxes div ferry_capacity) + ceil(min_boxes div rail_capacity): rail_trips;
var 0..2*(ceil(min_boxes div ferry_capacity) + ceil(min_boxes div rail_capacity)): total_trips;

% Constraints
constraint rail_trips >= rail_to_ferry_ratio * ferry_trips;

constraint ferry_capacity * ferry_trips + rail_capacity * rail_trips >= min_boxes;

constraint total_trips = ferry_trips + rail_trips;

% Objective
solve minimize total_trips;