include "globals.mzn";

%-----------------------------
% Data (embedded as requested)
%-----------------------------
int: C = 5;   % distribution centers
int: S = 9;   % stores

array[1..C] of int: openCost = [151000, 192000, 114000, 171000, 160000];

array[1..C, 1..S] of int: transCost =
  [| 5,2,3,3,3,5,4,3,5
   | 2,4,2,4,5,1,4,2,5
   | 4,1,1,3,3,2,4,4,3
   | 4,4,1,3,5,3,5,1,2
   | 4,1,4,2,2,1,2,5,2 |];

array[1..S] of int: demand = [739,491,766,854,827,908,434,605,480];

array[1..C] of int: capacity = [1825,1821,1365,1929,1502];

%-----------------------------
% Decision variables
%-----------------------------
array[1..C] of var 0..1: open;  % 1 if center is opened

% shipped[i,j] = units shipped from center i to store j
int: maxDem = max(demand);
array[1..C, 1..S] of var 0..maxDem: shipped;

%-----------------------------
% Constraints
%-----------------------------
% Meet each store's demand exactly
constraint forall(j in 1..S) (
  sum(i in 1..C)(shipped[i,j]) = demand[j]
);

% Respect each center's capacity, and force zero shipments if not open
constraint forall(i in 1..C) (
  sum(j in 1..S)(shipped[i,j]) <= capacity[i] * open[i]
);

%-----------------------------
% Objective: minimize total cost
%-----------------------------
var int: totalOpenCost = sum(i in 1..C)(openCost[i] * open[i]);
var int: totalTransCost = sum(i in 1..C, j in 1..S)(transCost[i,j] * shipped[i,j]);
var int: totalCost = totalOpenCost + totalTransCost;

solve minimize totalCost;

%-----------------------------
% Output
%-----------------------------
output [
  "Total cost = ", show(totalCost), "\n",
  "  Opening cost = ", show(totalOpenCost), "\n",
  "  Transport cost = ", show(totalTransCost), "\n\n",
  "Open centers (1..", show(C), ") = ", show(open), "\n",
  "Shipments (rows=center, cols=store):\n",
  concat([ concat([ show(shipped[i,j]) ++ if j==S then "\n" else "\t" endif
                   | j in 1..S ])
           | i in 1..C ])
];