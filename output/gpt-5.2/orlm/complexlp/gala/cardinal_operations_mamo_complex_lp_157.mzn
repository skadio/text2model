include "globals.mzn";

%----------------------------
% Data (embedded as requested)
%----------------------------
int: nCenters = 6;
int: nStores  = 5;

array[1..nCenters] of int: openCost =
  [151000, 192000, 114000, 171000, 160000, 120000];

array[1..nStores] of int: demand =
  [884, 420, 566, 673, 787];

array[1..nCenters] of int: capacity =
  [1400, 1115, 813, 1041, 1576, 1364];

array[1..nCenters, 1..nStores] of int: shipCost =
  [| 2, 3, 3, 3, 5
   | 4, 3, 5, 2, 4
   | 2, 4, 5, 1, 4
   | 2, 5, 4, 1, 1
   | 3, 3, 2, 4, 4
   | 3, 4, 4, 1, 3
  |];

% Upper bound on any shipment is total demand
int: totalDemand = sum(s in 1..nStores)(demand[s]);

%----------------------------
% Decision variables
%----------------------------
array[1..nCenters] of var 0..1: open;  % 1 if center is opened

array[1..nCenters, 1..nStores] of var 0..totalDemand: x; % units shipped

%----------------------------
% Constraints
%----------------------------
% Meet each store demand exactly
constraint forall(s in 1..nStores) (
  sum(c in 1..nCenters)(x[c,s]) = demand[s]
);

% Respect capacity if opened (and force shipments to 0 if closed)
constraint forall(c in 1..nCenters) (
  sum(s in 1..nStores)(x[c,s]) <= capacity[c] * open[c]
);

%----------------------------
% Objective: opening + transport
%----------------------------
var int: totalOpenCost =
  sum(c in 1..nCenters)(openCost[c] * open[c]);

var int: totalShipCost =
  sum(c in 1..nCenters, s in 1..nStores)(shipCost[c,s] * x[c,s]);

var int: totalCost = totalOpenCost + totalShipCost;

solve minimize totalCost;

%----------------------------
% Output
%----------------------------
output [
  "Total cost = ", show(totalCost), "\n",
  "Opening cost = ", show(totalOpenCost), "\n",
  "Shipping cost = ", show(totalShipCost), "\n\n",
  "Open centers (1..", show(nCenters), ") = ", show(open), "\n\n",
  "Shipments x[center,store]:\n",
  concat([ "Center " ++ show(c) ++ ": " ++ show([x[c,s] | s in 1..nStores]) ++ "\n"
         | c in 1..nCenters ])
];