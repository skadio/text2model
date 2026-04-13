include "globals.mzn";

%-----------------------------
% Data (embedded as requested)
%-----------------------------
int: nCenters = 5;
int: nStores  = 9;

array[1..nCenters] of int: openCost = [151000, 192000, 114000, 171000, 160000];

array[1..nStores] of int: demand = [739, 491, 685, 426, 446, 532, 446, 757, 480];

array[1..nCenters] of int: capacity = [1825, 1821, 1365, 1929, 1502];

% Transportation cost per unit from center i to store j
array[1..nCenters, 1..nStores] of int: shipCost =
[
  % stores:  1  2  3  4  5  6  7  8  9
            5, 2, 3, 4, 6, 5, 6, 7, 5,   % center 1
            2, 4, 6, 3, 5, 4, 3, 6, 5,   % center 2
            4, 3, 2, 5, 4, 6, 5, 4, 3,   % center 3
            6, 5, 4, 3, 2, 4, 6, 3, 4,   % center 4
            3, 6, 5, 4, 3, 2, 4, 5, 6    % center 5
];

%-----------------------------
% Decision variables
%-----------------------------
array[1..nCenters] of var 0..1: open;  % 1 if distribution center is opened

% x[i,j] = units shipped from center i to store j
int: maxDem = max(demand);
array[1..nCenters, 1..nStores] of var 0..maxDem: x;

%-----------------------------
% Constraints
%-----------------------------

% Each store demand must be met exactly
constraint forall(j in 1..nStores)(
  sum(i in 1..nCenters)(x[i,j]) = demand[j]
);

% Capacity constraints (only if center is open)
constraint forall(i in 1..nCenters)(
  sum(j in 1..nStores)(x[i,j]) <= capacity[i] * open[i]
);

%-----------------------------
% Objective
%-----------------------------
var int: totalOpenCost =
  sum(i in 1..nCenters)(openCost[i] * open[i]);

var int: totalShipCost =
  sum(i in 1..nCenters, j in 1..nStores)(shipCost[i,j] * x[i,j]);

var int: totalCost = totalOpenCost + totalShipCost;

solve minimize totalCost;

%-----------------------------
% Output
%-----------------------------
output [
  "Total cost = ", show(totalCost), "\n",
  "Open centers (1..", show(nCenters), ") = ", show(open), "\n",
  "Total opening cost = ", show(totalOpenCost), "\n",
  "Total shipping cost = ", show(totalShipCost), "\n",
  "Shipments x[center,store] (rows=centers):\n",
  concat([ show([x[i,j] | j in 1..nStores]) ++ "\n" | i in 1..nCenters ])
];