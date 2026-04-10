% Corn shipment optimization: minimize total trips

int: ferry_capacity = 20;
int: rail_capacity  = 15;

int: min_boxes = 500;

% Decision variables: number of trips (nonnegative integers)
var 0..1000: ferry_trips;
var 0..1000: rail_trips;

% Constraints
constraint ferry_capacity * ferry_trips + rail_capacity * rail_trips >= min_boxes;
constraint rail_trips >= 4 * ferry_trips;

% Objective: minimize total trips
solve minimize ferry_trips + rail_trips;

output [
  "ferry_trips=", show(ferry_trips), "\n",
  "rail_trips=", show(rail_trips), "\n",
  "total_trips=", show(ferry_trips + rail_trips), "\n",
  "boxes_sent=", show(ferry_capacity*ferry_trips + rail_capacity*rail_trips), "\n"
];