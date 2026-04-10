% Facility location / transportation model with embedded data
% Uses MIP to avoid timeout with default CP solver.

int: num_centers = 4;
int: num_outlets = 4;

set of int: CENTERS = 1..num_centers;
set of int: OUTLETS = 1..num_outlets;

array[CENTERS] of int: open_cost = [151000, 192000, 114000, 171000];

array[CENTERS, OUTLETS] of int: trans_cost =
  [| 5, 5, 2, 3
   | 3, 3, 5, 4
   | 3, 5, 2, 4
   | 2, 4, 5, 1 |];

array[OUTLETS] of int: demand = [859, 713, 421, 652];
array[CENTERS] of int: capacity = [1547, 1656, 1274, 1882];

int: total_demand = sum(o in OUTLETS)(demand[o]);

% Decision variables
array[CENTERS] of var 0..1: open;  % 1 if center is opened
array[CENTERS, OUTLETS] of var 0..total_demand: ship; % shipped units

% Demand satisfaction
constraint forall(o in OUTLETS) (
  sum(c in CENTERS)(ship[c,o]) = demand[o]
);

% Capacity linking (forces ship=0 when closed)
constraint forall(c in CENTERS) (
  sum(o in OUTLETS)(ship[c,o]) <= capacity[c] * open[c]
);

% Objective: fixed opening + variable transportation
var int: total_cost =
  sum(c in CENTERS)(open_cost[c] * open[c]) +
  sum(c in CENTERS, o in OUTLETS)(trans_cost[c,o] * ship[c,o]);

solve :: int_search([ship[c,o] | c in CENTERS, o in OUTLETS] ++ [open[c] | c in CENTERS],
                    first_fail, indomain_min, complete)
       minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "open = ", show(open), "\n",
  "ship = ", show(ship), "\n"
];