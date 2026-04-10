% MarketHub distribution network design (facility location + transportation)
% Data is embedded as requested.

include "globals.mzn";

int: m = 8; % potential distribution centers
int: n = 5; % retail stores

set of int: C = 1..m;
set of int: S = 1..n;

array[C] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

array[C,S] of int: transCost =
  [| 3, 3, 5, 4, 3
   | 5, 2, 4, 2, 4
   | 5, 1, 4, 2, 5
   | 4, 1, 1, 3, 3
   | 2, 4, 4, 3, 4
   | 4, 1, 3, 5, 3
   | 5, 1, 2, 4, 1
   | 4, 2, 2, 1, 2 |];

array[S] of int: demand = [964, 739, 491, 766, 854];
array[C] of int: cap    = [1308, 1575, 834, 1005, 1904, 1825, 1821, 1365];

int: totalDemand = sum(s in S)(demand[s]);

% Decision variables
array[C] of var 0..1: open;                 % 1 if center is opened
array[C,S] of var 0..totalDemand: ship;     % units shipped from center c to store s

% Demand satisfaction
constraint forall(s in S)(
  sum(c in C)(ship[c,s]) = demand[s]
);

% Capacity and linking to opening decisions
constraint forall(c in C)(
  sum(s in S)(ship[c,s]) <= cap[c] * open[c]
);

% Objective: opening + transportation
var int: totalOpenCost = sum(c in C)(openCost[c] * open[c]);
var int: totalTransCost = sum(c in C, s in S)(transCost[c,s] * ship[c,s]);
var int: totalCost = totalOpenCost + totalTransCost;

solve minimize totalCost;

output [
  "Total cost = ", show(totalCost), "\n",
  "  Opening cost = ", show(totalOpenCost), "\n",
  "  Transport cost = ", show(totalTransCost), "\n\n",
  "Open centers (1..", show(m), ") = ", show(open), "\n\n",
  "Shipments (rows=center, cols=store):\n",
  concat([ concat([ show(ship[c,s]) ++ if s<n then "\t" else "" endif | s in S ]) ++ "\n" | c in C ])
];