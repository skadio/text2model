include "globals.mzn";

% ----------------------------
% Data (embedded as requested)
% ----------------------------
int: nDC = 8;
int: nStore = 5;

array[1..nDC] of int: openCost = [
  151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000
];

array[1..nDC, 1..nStore] of int: shipCost = array2d(1..nDC, 1..nStore, [
  3,3,5,4,3,
  5,2,4,2,4,
  5,1,4,2,5,
  4,1,1,3,3,
  2,4,4,3,4,
  4,1,3,5,3,
  5,1,2,4,1,
  4,2,2,1,2
]);

array[1..nStore] of int: demand = [964, 739, 491, 766, 854];

array[1..nDC] of int: capacity = [1308, 1575, 834, 1005, 1904, 1825, 1821, 1365];

int: totalDemand = sum(j in 1..nStore)(demand[j]);

% ----------------------------
% Decision variables
% ----------------------------
array[1..nDC] of var 0..1: open;  % 1 if distribution center is opened

% flow[i,j] = units shipped from DC i to Store j
array[1..nDC, 1..nStore] of var 0..totalDemand: flow;

% ----------------------------
% Constraints
% ----------------------------

% Each store's demand must be met exactly
constraint forall(j in 1..nStore) (
  sum(i in 1..nDC)(flow[i,j]) = demand[j]
);

% Capacity constraints, only if opened (big-M via capacity)
constraint forall(i in 1..nDC) (
  sum(j in 1..nStore)(flow[i,j]) <= capacity[i] * open[i]
);

% ----------------------------
% Objective: opening + transport costs
% ----------------------------
var int: totalOpenCost = sum(i in 1..nDC)(openCost[i] * open[i]);
var int: totalShipCost = sum(i in 1..nDC, j in 1..nStore)(shipCost[i,j] * flow[i,j]);
var int: totalCost = totalOpenCost + totalShipCost;

solve minimize totalCost;

% ----------------------------
% Output
% ----------------------------
output [
  "Total cost = ", show(totalCost), "\n",
  "  Opening cost = ", show(totalOpenCost), "\n",
  "  Shipping cost = ", show(totalShipCost), "\n\n",
  "Open DCs (1..", show(nDC), ") = ", show(open), "\n\n",
  "Flow matrix (DC x Store):\n",
  concat([ concat([ "DC ", show(i), ": ", show([flow[i,j] | j in 1..nStore]), "\n" ])
           | i in 1..nDC ])
];