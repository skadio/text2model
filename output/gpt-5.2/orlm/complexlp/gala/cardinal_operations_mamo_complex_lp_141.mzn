include "globals.mzn";

%----------------------------
% Data (embedded)
%----------------------------
int: nCenters = 4;
int: nStores  = 6;

set of int: Centers = 1..nCenters;
set of int: Stores  = 1..nStores;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000];

array[Centers, Stores] of int: unitCost =
[
  | 5, 5, 2, 3, 3, 3  % Center 1 -> Stores 1..6
  | 5, 4, 3, 5, 2, 4  % Center 2
  | 2, 4, 5, 1, 4, 2  % Center 3
  | 5, 4, 1, 1, 3, 3  % Center 4
];

array[Stores] of int: demand = [910, 875, 589, 962, 966, 643];
array[Centers] of int: capacity = [1631, 1954, 1446, 820];

int: totalDemand = sum(s in Stores)(demand[s]);

%----------------------------
% Decision variables
%----------------------------
array[Centers] of var 0..1: open;  % 1 if center is opened

% shipped[c,s] = units shipped from center c to store s
array[Centers, Stores] of var 0..totalDemand: shipped;

%----------------------------
% Constraints
%----------------------------

% Each store's demand must be met exactly
constraint forall(s in Stores)(
  sum(c in Centers)(shipped[c,s]) = demand[s]
);

% Each center cannot exceed its capacity, and cannot ship if not opened
constraint forall(c in Centers)(
  sum(s in Stores)(shipped[c,s]) <= capacity[c] * open[c]
);

%----------------------------
% Objective: opening + transportation costs
%----------------------------
var int: totalOpenCost = sum(c in Centers)(openCost[c] * open[c]);
var int: totalShipCost = sum(c in Centers, s in Stores)(unitCost[c,s] * shipped[c,s]);
var int: totalCost = totalOpenCost + totalShipCost;

solve minimize totalCost;

%----------------------------
% Output
%----------------------------
output [
  "TotalCost = ", show(totalCost), "\n",
  "Open = ", show(open), "\n",
  "TotalOpenCost = ", show(totalOpenCost), "\n",
  "TotalShipCost = ", show(totalShipCost), "\n",
  "Shipped (rows=centers, cols=stores) =\n",
  show(shipped), "\n"
];