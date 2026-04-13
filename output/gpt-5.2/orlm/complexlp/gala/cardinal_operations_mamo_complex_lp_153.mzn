include "globals.mzn";

% -----------------------------
% Data (embedded as requested)
% -----------------------------
int: nCenters = 4;
int: nStores  = 6;

set of int: Centers = 1..nCenters;
set of int: Stores  = 1..nStores;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000];

array[Centers, Stores] of int: shipCost =
[
  | 5, 5, 2, 3, 3, 3  % Center 1 -> Stores 1..6
  | 5, 4, 3, 5, 2, 4  % Center 2
  | 2, 4, 5, 1, 4, 2  % Center 3
  | 5, 4, 1, 1, 3, 3  % Center 4
];

array[Stores] of int: demand = [910, 875, 589, 962, 966, 643];
array[Centers] of int: capacity = [1631, 1954, 1446, 820];

% -----------------------------
% Decision variables
% -----------------------------
array[Centers] of var 0..1: open;                         % 1 if center is opened
array[Centers, Stores] of var 0..max(demand): flow;       % units shipped from center c to store s

% -----------------------------
% Constraints
% -----------------------------

% Meet each store's demand exactly
constraint
  forall(s in Stores)(
    sum(c in Centers)(flow[c,s]) = demand[s]
  );

% Respect capacity if opened; otherwise ship nothing
constraint
  forall(c in Centers)(
    sum(s in Stores)(flow[c,s]) <= capacity[c] * open[c]
  );

% -----------------------------
% Objective: opening + shipping costs
% -----------------------------
var int: totalOpenCost = sum(c in Centers)(openCost[c] * open[c]);
var int: totalShipCost = sum(c in Centers, s in Stores)(shipCost[c,s] * flow[c,s]);
var int: totalCost = totalOpenCost + totalShipCost;

solve minimize totalCost;

% -----------------------------
% Output
% -----------------------------
output [
  "Opened centers (1=open,0=closed): ", show(open), "\n",
  "Total opening cost: ", show(totalOpenCost), "\n",
  "Total shipping cost: ", show(totalShipCost), "\n",
  "Optimal total cost: ", show(totalCost), "\n",
  "Flows (rows=centers, cols=stores):\n",
  concat([ concat([ show(flow[c,s]) ++ if s==nStores then "\n" else "\t" endif
                  | s in Stores ])
         | c in Centers ])
];