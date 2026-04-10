include "globals.mzn";

%----------------------------
% Data (embedded as requested)
%----------------------------
int: nCenters = 9;
int: nStores  = 6;

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost = [
  151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000
];

array[CENTERS, STORES] of int: shipCost = array2d(CENTERS, STORES, [
  3,5,4,3,5,2,   % center 1 -> stores 1..6
  4,2,4,5,1,4,   % center 2
  2,5,4,1,1,3,   % center 3
  3,2,4,4,3,4,   % center 4
  4,1,3,5,3,5,   % center 5
  1,2,4,1,4,2,   % center 6
  2,1,2,5,2,4,   % center 7
  4,4,4,5,3,1,   % center 8
  4,2,4,2,2,4    % center 9
]);

array[STORES] of int: demand = [876, 801, 955, 561, 601, 669];

array[CENTERS] of int: capacity = [1615, 1255, 1816, 1095, 1519, 1137, 1678, 1876, 1591];

%----------------------------
% Decision variables
%----------------------------
array[CENTERS] of var 0..1: open;                 % 1 if distribution center is opened
array[CENTERS, STORES] of var 0..max(demand): x;  % units shipped from center i to store j

%----------------------------
% Constraints
%----------------------------

% Meet each store's demand exactly
constraint forall(j in STORES)(
  sum(i in CENTERS)(x[i,j]) = demand[j]
);

% Do not exceed each center's capacity (and force 0 shipment if not opened)
constraint forall(i in CENTERS)(
  sum(j in STORES)(x[i,j]) <= capacity[i] * open[i]
);

%----------------------------
% Objective: minimize total cost
%----------------------------
var int: totalOpenCost = sum(i in CENTERS)(openCost[i] * open[i]);
var int: totalShipCost = sum(i in CENTERS, j in STORES)(shipCost[i,j] * x[i,j]);
var int: totalCost = totalOpenCost + totalShipCost;

solve minimize totalCost;

%----------------------------
% Output
%----------------------------
output [
  "Total cost = ", show(totalCost), "\n",
  "  Opening cost = ", show(totalOpenCost), "\n",
  "  Shipping cost = ", show(totalShipCost), "\n\n",
  "Open centers (1=open): ", show(open), "\n\n",
  "Shipments x[center,store] (units):\n",
  concat([ "Center " ++ show(i) ++ ": " ++ show([x[i,j] | j in STORES]) ++ "\n" | i in CENTERS ])
];