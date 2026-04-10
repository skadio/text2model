% Parameters
int: ferry_capacity = 20;
int: rail_capacity = 15;
int: min_boxes = 500;
int: rail_multiplier = 4;

% Variables
var 0..ceil(min_boxes div ferry_capacity): ferry_trips;
var 0..ceil(min_boxes div rail_capacity): rail_trips;

% Constraints
constraint ferry_capacity * ferry_trips + rail_capacity * rail_trips >= min_boxes;
constraint rail_trips >= rail_multiplier * ferry_trips;

% Objective
solve minimize ferry_trips + rail_trips;