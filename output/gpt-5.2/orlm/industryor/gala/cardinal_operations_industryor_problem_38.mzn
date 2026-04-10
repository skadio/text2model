include "globals.mzn";

% Transportation methods: 1=motorcycle, 2=small truck, 3=large truck
set of int: M = 1..3;

array[M] of int: pollution = [40, 70, 100];
array[M] of int: capacity  = [10, 20, 50];

int: maxMotoTrips = 8;
int: minDemand    = 300;
int: maxTotalTrips = 20;

% Decision variables: number of trips by each method
array[M] of var 0..maxTotalTrips: trips;

% Whether a method is used (1) or not (0)
array[M] of var 0..1: use;

% Exactly two methods may be chosen (used)
constraint forall(m in M)(
  trips[m] <= maxTotalTrips * use[m] /\
  trips[m] >= use[m]
);
constraint sum(m in M)(use[m]) = 2;

% Road restriction on motorcycles
constraint trips[1] <= maxMotoTrips;

% Total number of trips limited
constraint sum(m in M)(trips[m]) <= maxTotalTrips;

% Must transport at least the required demand
constraint sum(m in M)(capacity[m] * trips[m]) >= minDemand;

% Objective: minimize total pollution
var int: totalPollution = sum(m in M)(pollution[m] * trips[m]);

solve minimize totalPollution;

output [
  "Trips (motorcycle, small, large) = ", show([trips[1], trips[2], trips[3]]), "\n",
  "Use   (motorcycle, small, large) = ", show([use[1], use[2], use[3]]), "\n",
  "Total trips = ", show(sum(m in M)(trips[m])), "\n",
  "Total capacity = ", show(sum(m in M)(capacity[m] * trips[m])), "\n",
  "Total pollution = ", show(totalPollution), "\n"
];