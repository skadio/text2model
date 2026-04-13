include "globals.mzn";

%--------------------------
% Data (embedded)
%--------------------------
int: nCenters = 6;
int: nStores  = 7;

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost =
  [151000, 192000, 114000, 171000, 160000, 120000];

array[CENTERS, STORES] of int: transCost =
  [| 2, 3, 3, 3, 5, 4, 3
   | 5, 2, 4, 2, 4, 5, 1
   | 4, 2, 5, 4, 1, 1, 3
   | 3, 2, 4, 4, 3, 4, 4
   | 1, 3, 5, 3, 5, 1, 2
   | 4, 1, 4, 2, 2, 1, 2 |];

array[STORES] of int: demand =
  [964, 739, 491, 766, 854, 827, 908];

array[CENTERS] of int: capacity =
  [1575, 834, 1005, 1904, 1825, 1821];

%--------------------------
% Variables
%--------------------------
array[CENTERS] of var bool: open;

% Upper bound tightened per arc to speed up solving
array[CENTERS, STORES] of var 0..max(capacity[1], max(capacity[2], max(capacity[3], max(capacity[4], max(capacity[5], capacity[6]))))): ship;

%--------------------------
% Constraints
%--------------------------

% Demand must be met exactly
constraint forall(s in STORES) (
  sum(c in CENTERS)(ship[c,s]) = demand[s]
);

% Capacity / opening linking (big-M with capacity)
constraint forall(c in CENTERS) (
  sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
);

% Strengthening: each arc cannot exceed store demand and center capacity
constraint forall(c in CENTERS, s in STORES) (
  ship[c,s] <= demand[s] /\
  ship[c,s] <= capacity[c]
);

%--------------------------
% Objective
%--------------------------
var int: total_cost =
    sum(c in CENTERS)(openCost[c] * bool2int(open[c]))
  + sum(c in CENTERS, s in STORES)(transCost[c,s] * ship[c,s]);

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "open=", show([bool2int(open[c]) | c in CENTERS]), "\n"
];