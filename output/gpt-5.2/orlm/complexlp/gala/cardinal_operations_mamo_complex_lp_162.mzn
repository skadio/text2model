include "globals.mzn";

%----------------------------
% Data (embedded as requested)
%----------------------------
int: nCenters = 7;
int: nStores  = 4;

array[1..nCenters] of int: openCost =
  [151000, 192000, 114000, 171000, 160000, 120000, 182000];

array[1..nCenters] of int: capacity =
  [1187, 1400, 1115, 813, 1041, 1576, 1364];

array[1..nStores] of int: demand =
  [884, 420, 566, 673];

array[1..nCenters, 1..nStores] of int: transCost =
  [| 3, 3, 5, 4
   | 3, 5, 2, 4
   | 2, 4, 5, 1
   | 4, 2, 5, 4
   | 1, 1, 3, 3
   | 2, 4, 4, 3
   | 4, 4, 1, 3 |];

%----------------------------
% Decision variables
%----------------------------
array[1..nCenters] of var 0..1: open;  % 1 if center is opened
array[1..nCenters, 1..nStores] of var 0..max(demand): ship; % units shipped i->j

%----------------------------
% Constraints
%----------------------------

% Meet each store's demand exactly
constraint forall(j in 1..nStores) (
  sum(i in 1..nCenters)(ship[i,j]) = demand[j]
);

% Respect each center capacity and enforce "if not open, ship = 0"
constraint forall(i in 1..nCenters) (
  sum(j in 1..nStores)(ship[i,j]) <= capacity[i] * open[i]
);

%----------------------------
% Objective: opening + transport costs
%----------------------------
var int: totalOpenCost =
  sum(i in 1..nCenters)(openCost[i] * open[i]);

var int: totalTransportCost =
  sum(i in 1..nCenters, j in 1..nStores)(transCost[i,j] * ship[i,j]);

var int: totalCost = totalOpenCost + totalTransportCost;

solve minimize totalCost;

%----------------------------
% Output
%----------------------------
output [
  "Minimum total cost = ", show(totalCost), "\n",
  "  Opening cost     = ", show(totalOpenCost), "\n",
  "  Transport cost   = ", show(totalTransportCost), "\n\n",
  "Open centers (1..", show(nCenters), ") = ", show(open), "\n\n",
  "Shipments ship[center,store]:\n",
  concat([ "Center " ++ show(i) ++ ": " ++
           show([ ship[i,j] | j in 1..nStores ]) ++ "\n"
         | i in 1..nCenters ])
];