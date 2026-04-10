include "globals.mzn";

% Data (embedded from the problem statement)
int: boat_capacity = 10;
int: canoe_capacity = 8;

int: boat_time = 20;   % minutes per trip
int: canoe_time = 40;  % minutes per trip

int: max_boat_trips = 12;
int: min_ducks = 300;

% Decision variables
var 0..max_boat_trips: boat_trips;
var 0..1000: canoe_trips;  % safe upper bound

% Constraints
constraint boat_capacity * boat_trips + canoe_capacity * canoe_trips >= min_ducks;

% At least 60% of all trips are by canoe:
% canoe_trips / (boat_trips + canoe_trips) >= 0.60
% => 5*canoe_trips >= 3*(boat_trips + canoe_trips)
% => 2*canoe_trips >= 3*boat_trips
constraint 2 * canoe_trips >= 3 * boat_trips;

% Objective: minimize total transport time
var int: total_time = boat_time * boat_trips + canoe_time * canoe_trips;

solve minimize total_time;

output [
  "boat_trips = ", show(boat_trips), "\n",
  "canoe_trips = ", show(canoe_trips), "\n",
  "total_trips = ", show(boat_trips + canoe_trips), "\n",
  "ducks_moved = ", show(boat_capacity * boat_trips + canoe_capacity * canoe_trips), "\n",
  "total_time_minutes = ", show(total_time), "\n"
];