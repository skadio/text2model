% Facility Location / Transportation Problem
% Data embedded as requested

int: num_centers = 7;
int: num_stores  = 9;

set of int: CENTERS = 1..num_centers;
set of int: STORES  = 1..num_stores;

array[CENTERS] of int: open_cost =
  [151000, 192000, 114000, 171000, 160000, 120000, 182000];

array[CENTERS, STORES] of int: ship_cost =
  [| 1, 2, 3, 4, 5, 1, 2, 3, 4
   | 2, 3, 4, 5, 1, 2, 3, 4, 5
   | 3, 4, 5, 1, 2, 3, 4, 5, 1
   | 4, 5, 1, 2, 3, 4, 5, 1, 2
   | 5, 1, 2, 3, 4, 5, 1, 2, 3
   | 1, 3, 5, 2, 4, 1, 3, 5, 2
   | 2, 4, 1, 3, 5, 2, 4, 1, 3 |];

array[STORES] of int: demand =
  [440, 520, 610, 705, 892, 460, 530, 650, 780];

array[CENTERS] of int: capacity =
  [814, 950, 1200, 1500, 1962, 1000, 1400];

int: total_demand = sum(j in STORES)(demand[j]);

% Decision variables
array[CENTERS] of var bool: open; % true if center i is opened

% Shipments (upper bounded by min(capacity[i], total_demand) to tighten domains)
array[CENTERS, STORES] of var 0..total_demand: ship;

% Constraints

% Demand satisfaction
constraint
  forall(j in STORES) (
    sum(i in CENTERS)(ship[i,j]) = demand[j]
  );

% Capacity + opening linkage
constraint
  forall(i in CENTERS) (
    sum(j in STORES)(ship[i,j]) <= capacity[i] * bool2int(open[i])
  );

% Optional strengthening: per-arc bound by capacity if open, else 0
constraint
  forall(i in CENTERS, j in STORES) (
    ship[i,j] <= capacity[i] * bool2int(open[i])
  );

% Objective: MINIMIZE total fixed + variable transport cost
var int: total_cost =
  sum(i in CENTERS)(open_cost[i] * bool2int(open[i])) +
  sum(i in CENTERS, j in STORES)(ship_cost[i,j] * ship[i,j]);

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "open=", show([bool2int(open[i]) | i in CENTERS]), "\n"
];