include "globals.mzn";

% Data (embedded from problem statement)
int: ferry_capacity = 20;
int: rail_capacity  = 15;
int: min_boxes      = 500;

% Decision variables: number of trips
var 0..ceil(min_boxes div min(ferry_capacity, rail_capacity)) + 100: ferry_trips;
var 0..ceil(min_boxes div min(ferry_capacity, rail_capacity)) + 100: rail_trips;

% Constraints
constraint rail_trips >= 4 * ferry_trips;
constraint ferry_capacity * ferry_trips + rail_capacity * rail_trips >= min_boxes;

% Objective: minimize total trips
var int: total_trips = ferry_trips + rail_trips;
solve minimize total_trips;

output [
  "ferry_trips = ", show(ferry_trips), "\n",
  "rail_trips  = ", show(rail_trips),  "\n",
  "total_trips = ", show(total_trips), "\n",
  "boxes_sent  = ", show(ferry_capacity * ferry_trips + rail_capacity * rail_trips), "\n"
];