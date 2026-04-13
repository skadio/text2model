% Transport planning to minimize pollution

int: demand = 1000;
int: pollution_limit = 1000;

set of int: M = 1..3;
int: HORSE = 1;
int: BICYCLE = 2;
int: HANDCART = 3;

array[M] of int: capacity = [55, 30, 40];
array[M] of int: pollution = [80, 0, 0];

int: min_horse_trips = 8;

% Decision variables: number of trips for each method
array[M] of var 0..10000: trips;

% Choose only one of bicycle or handcart (the other must be zero)
constraint (trips[BICYCLE] = 0) \/ (trips[HANDCART] = 0);

% At least 8 horse trips
constraint trips[HORSE] >= min_horse_trips;

% Pollution limit
constraint sum(m in M)(pollution[m] * trips[m]) <= pollution_limit;

% Meet produce demand
constraint sum(m in M)(capacity[m] * trips[m]) >= demand;

% Objective: minimize total pollution
var int: total_pollution = sum(m in M)(pollution[m] * trips[m]);
solve minimize total_pollution;

output [
  "Horse trips: ", show(trips[HORSE]), "\n",
  "Bicycle trips: ", show(trips[BICYCLE]), "\n",
  "Handcart trips: ", show(trips[HANDCART]), "\n",
  "Total transported: ", show(sum(m in M)(capacity[m] * trips[m])), "\n",
  "Total pollution: ", show(total_pollution), "\n"
];