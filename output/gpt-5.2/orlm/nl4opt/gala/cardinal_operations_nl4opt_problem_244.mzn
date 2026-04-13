include "globals.mzn";

% Data (embedded as requested)
int: plane_capacity = 10;
int: truck_capacity = 6;
int: plane_cost = 1000;
int: truck_cost = 700;

int: demand = 200;        % at least this many tires
int: budget = 22000;      % at most this much money

% Decision variables: number of trips (nonnegative integers)
var 0..(budget div plane_cost): plane_trips;
var 0..(budget div truck_cost): truck_trips;

% Constraints
constraint plane_capacity * plane_trips + truck_capacity * truck_trips >= demand;
constraint plane_cost * plane_trips + truck_cost * truck_trips <= budget;
constraint plane_trips <= truck_trips;

% Objective: minimize total number of trips
var 0..(budget div plane_cost + budget div truck_cost): total_trips =
  plane_trips + truck_trips;

solve minimize total_trips;

output [
  "plane_trips = ", show(plane_trips), "\n",
  "truck_trips = ", show(truck_trips), "\n",
  "total_trips = ", show(total_trips), "\n",
  "tires_moved = ", show(plane_capacity * plane_trips + truck_capacity * truck_trips), "\n",
  "total_cost = ", show(plane_cost * plane_trips + truck_cost * truck_trips), "\n"
];