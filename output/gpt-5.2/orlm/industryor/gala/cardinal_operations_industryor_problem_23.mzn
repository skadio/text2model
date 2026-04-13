include "globals.mzn";

% Data (embedded)
int: demand = 1800;

set of int: T = 1..4; % 1=truck, 2=van, 3=motorcycle, 4=electric
array[T] of int: cap = [100, 80, 40, 60];
array[T] of int: pol = [100, 50, 10, 0];

int: polLimit = 2000;
int: minTrucks = 10;

% Decision variables: number of trips by each vehicle type
array[T] of var 0..1000: trips;

% Either vans or electric vehicles, but not both (i.e., at least one of them is unused)
constraint trips[2] = 0 \/ trips[4] = 0;

% Minimum delivered units
var 0..1000000: delivered = sum(t in T)(cap[t] * trips[t]);
constraint delivered >= demand;

% Pollution limit
var 0..1000000: totalPollution = sum(t in T)(pol[t] * trips[t]);
constraint totalPollution <= polLimit;

% At least 10 truck trips
constraint trips[1] >= minTrucks;

% Objective: minimize total pollution
solve minimize totalPollution;

output [
  "Minimum total pollution = ", show(totalPollution), "\n",
  "Trips (truck, van, motorcycle, electric) = ", show(trips), "\n",
  "Delivered units = ", show(delivered), "\n"
];