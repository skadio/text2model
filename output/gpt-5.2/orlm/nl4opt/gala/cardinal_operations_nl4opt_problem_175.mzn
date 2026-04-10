include "globals.mzn";

% Data (embedded as required)
int: van_capacity = 50;
int: truck_capacity = 80;
int: van_cost = 30;
int: truck_cost = 50;

int: min_boxes = 1500;
int: budget = 1000;

% Decision variables: number of trips (nonnegative integers)
% Upper bounds derived from budget
int: max_van_trips = budget div van_cost;     % 33
int: max_truck_trips = budget div truck_cost; % 20

var 0..max_van_trips: van_trips;
var 0..max_truck_trips: truck_trips;

% Constraints
constraint van_capacity * van_trips + truck_capacity * truck_trips >= min_boxes;
constraint van_cost * van_trips + truck_cost * truck_trips <= budget;
constraint van_trips > truck_trips; % vans must be more than trucks

% Objective: minimize total number of trips
var 0..(max_van_trips + max_truck_trips): total_trips = van_trips + truck_trips;
solve minimize total_trips;

output [
  "van_trips = ", show(van_trips), "\n",
  "truck_trips = ", show(truck_trips), "\n",
  "total_trips = ", show(total_trips), "\n",
  "boxes_moved = ", show(van_capacity * van_trips + truck_capacity * truck_trips), "\n",
  "total_cost = ", show(van_cost * van_trips + truck_cost * truck_trips), "\n"
];