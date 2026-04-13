include "globals.mzn";

% Facility location / transportation problem (fixed-charge + flow)
int: m = 4; % distribution centers
int: n = 4; % stores

set of int: C = 1..m;
set of int: S = 1..n;

array[C] of int: openCost = [151000, 192000, 114000, 171000];

array[C,S] of int: shipCost =
  [| 5, 5, 2, 3
   | 3, 3, 5, 4
   | 3, 5, 2, 4
   | 2, 4, 5, 1 |];

array[S] of int: demand = [859, 713, 421, 652];
array[C] of int: cap    = [1547, 1656, 1274, 1882];

int: totalDemand = sum(s in S)(demand[s]);

% Decision variables
array[C] of var 0..1: open;
array[C,S] of var 0..totalDemand: ship;   % units shipped from center c to store s

% Demand satisfaction (each store fully supplied)
constraint forall(s in S)(
  sum(c in C)(ship[c,s]) = demand[s]
);

% Capacity at each center, enabled only if open
constraint forall(c in C)(
  sum(s in S)(ship[c,s]) <= cap[c] * open[c]
);

% Objective: fixed opening + transportation
var int: totalOpenCost = sum(c in C)(openCost[c] * open[c]);
var int: totalShipCost = sum(c in C, s in S)(shipCost[c,s] * ship[c,s]);
var int: totalCost = totalOpenCost + totalShipCost;

solve minimize totalCost;

output [
  "Open = ", show(open), "\n",
  "Ship = ", show(ship), "\n",
  "TotalOpenCost = ", show(totalOpenCost), "\n",
  "TotalShipCost = ", show(totalShipCost), "\n",
  "TotalCost = ", show(totalCost), "\n"
];