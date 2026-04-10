include "globals.mzn";

%-----------------------------
% Data (embedded as requested)
%-----------------------------
int: m = 5;   % distribution centers
int: n = 9;   % retail stores

set of int: DC = 1..m;
set of int: ST = 1..n;

array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000];

array[DC, ST] of int: shipCost = 
  [| 5, 2, 3, 3, 3, 5, 4, 3, 5   % DC1 -> stores 1..9
   | 2, 4, 2, 4, 5, 1, 4, 2, 5   % DC2
   | 4, 1, 1, 3, 3, 2, 4, 4, 3   % DC3
   | 4, 4, 1, 3, 5, 3, 5, 1, 2   % DC4
   | 4, 1, 4, 2, 2, 1, 2, 5, 2   % DC5
  |];

array[ST] of int: demand = [739, 491, 766, 854, 827, 908, 434, 605, 480];
array[DC] of int: capacity = [1825, 1821, 1365, 1929, 1502];

% Upper bound on any shipped quantity to a store is its full demand
array[ST] of int: maxShipToStore = demand;

%-----------------------------
% Decision variables
%-----------------------------
array[DC] of var 0..1: open;

% x[d,s] = units shipped from DC d to store s
array[DC, ST] of var 0..max(demand): x;

%-----------------------------
% Constraints
%-----------------------------
% Demand satisfaction: each store must receive exactly its demand
constraint forall(s in ST)(
  sum(d in DC)(x[d,s]) = demand[s]
);

% Capacity: total shipped from a DC cannot exceed its capacity if opened; otherwise 0
constraint forall(d in DC)(
  sum(s in ST)(x[d,s]) <= capacity[d] * open[d]
);

% Optional tightening: if a DC is closed, it ships nothing (implied by capacity, but helps)
constraint forall(d in DC, s in ST)(
  x[d,s] <= maxShipToStore[s] * open[d]
);

%-----------------------------
% Objective: opening + transport
%-----------------------------
var int: totalOpenCost = sum(d in DC)(openCost[d] * open[d]);
var int: totalShipCost = sum(d in DC, s in ST)(shipCost[d,s] * x[d,s]);
var int: totalCost = totalOpenCost + totalShipCost;

solve minimize totalCost;

%-----------------------------
% Output
%-----------------------------
output [
  "Total cost = ", show(totalCost), "\n",
  "  Opening cost = ", show(totalOpenCost), "\n",
  "  Shipping cost = ", show(totalShipCost), "\n\n",
  "Open centers (1=open): ", show(open), "\n\n",
  "Shipments x[dc,store] (units):\n",
  concat([ "DC " ++ show(d) ++ ": " ++ show([x[d,s] | s in ST]) ++ "\n" | d in DC ])
];