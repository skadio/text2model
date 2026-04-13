include "globals.mzn";

%-----------------------------
% Data (embedded as requested)
%-----------------------------
int: nCenters = 7;
int: nStores  = 5;

array[1..nCenters] of int: openCost =
  [151000, 192000, 114000, 171000, 160000, 120000, 182000];

array[1..nStores] of int: demand =
  [715, 413, 641, 745, 964];

array[1..nCenters] of int: capacity =
  [1697, 891, 1755, 1308, 1575, 834, 1005];

array[1..nCenters, 1..nStores] of int: transCost = array2d(1..nCenters, 1..nStores,
[
  3,3,5,4,3,
  5,2,4,2,4,
  5,1,4,2,5,
  4,1,1,3,3,
  2,4,4,3,4,
  4,1,3,5,3,
  5,1,2,4,1
]);

int: totalDemand = sum(j in 1..nStores)(demand[j]);

% Upper bound on any shipment lane: can't exceed store demand or center capacity
array[1..nCenters, 1..nStores] of int: shipUB =
  array2d(1..nCenters, 1..nStores,
    [ min(capacity[i], demand[j]) | i in 1..nCenters, j in 1..nStores ]);

%-----------------------------
% Decision variables
%-----------------------------
array[1..nCenters] of var 0..1: open;  % 1 if center is opened
array[1..nCenters, 1..nStores] of var 0..max(demand): ship; % units shipped i->j

%-----------------------------
% Constraints
%-----------------------------

% Meet each store's demand exactly
constraint forall(j in 1..nStores)(
  sum(i in 1..nCenters)(ship[i,j]) = demand[j]
);

% Do not exceed each center's capacity, and ship only if opened
constraint forall(i in 1..nCenters)(
  sum(j in 1..nStores)(ship[i,j]) <= capacity[i] * open[i]
);

% Tighten per-lane shipments
constraint forall(i in 1..nCenters, j in 1..nStores)(
  ship[i,j] <= shipUB[i,j] * open[i]
);

%-----------------------------
% Objective
%-----------------------------
var int: totalOpenCost = sum(i in 1..nCenters)(openCost[i] * open[i]);
var int: totalTransCost = sum(i in 1..nCenters, j in 1..nStores)(transCost[i,j] * ship[i,j]);
var int: totalCost = totalOpenCost + totalTransCost;

solve minimize totalCost;

%-----------------------------
% Output
%-----------------------------
output [
  "TotalCost = ", show(totalCost), "\n",
  "OpenCost  = ", show(totalOpenCost), "\n",
  "TransCost = ", show(totalTransCost), "\n\n",
  "Open centers (1..", show(nCenters), ") = ", show(open), "\n\n",
  "Shipments (rows=centers, cols=stores):\n",
  concat([ concat([ if j=1 then "" else " " endif ++ show(ship[i,j]) | j in 1..nStores]) ++ "\n"
           | i in 1..nCenters ])
];