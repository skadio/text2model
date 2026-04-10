include "globals.mzn";

%-----------------------------
% Data (embedded as requested)
%-----------------------------
int: nCenters = 5;
int: nStores  = 5;

set of int: Centers = 1..nCenters;
set of int: Stores  = 1..nStores;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000];

array[Centers, Stores] of int: transCost =
  [| 5, 2, 3, 3, 3
   | 5, 4, 3, 5, 2
   | 4, 2, 4, 5, 1
   | 4, 2, 5, 4, 1
   | 1, 3, 3, 2, 4 |];

array[Stores] of int: demand = [589, 962, 966, 643, 904];

array[Centers] of int: capacity = [1954, 1446, 820, 1640, 966];

%-----------------------------
% Decision variables
%-----------------------------
array[Centers] of var 0..1: open; % 1 if center is opened

% shipped[c,s] = units shipped from center c to store s
array[Centers, Stores] of var 0..max(demand): shipped;

%-----------------------------
% Constraints
%-----------------------------

% Meet each store's demand exactly
constraint forall(s in Stores)(
  sum(c in Centers)(shipped[c,s]) = demand[s]
);

% Do not exceed each center's capacity; if not open, ship nothing
constraint forall(c in Centers)(
  sum(s in Stores)(shipped[c,s]) <= capacity[c] * open[c]
);

% (Optional strengthening) if a center is open, it may still ship 0; no extra constraint needed.

%-----------------------------
% Objective
%-----------------------------
var int: totalOpenCost  = sum(c in Centers)(openCost[c] * open[c]);
var int: totalTransCost = sum(c in Centers, s in Stores)(transCost[c,s] * shipped[c,s]);
var int: totalCost = totalOpenCost + totalTransCost;

solve minimize totalCost;

%-----------------------------
% Output
%-----------------------------
output [
  "Total cost = ", show(totalCost), "\n",
  "  Open cost = ", show(totalOpenCost), "\n",
  "  Transport cost = ", show(totalTransCost), "\n\n",
  "Open centers (1=open): ", show(open), "\n\n",
  "Shipments (rows=centers, cols=stores):\n",
  concat([ concat([ if s=1 then "" else " " endif ++ show(shipped[c,s])
                    | s in Stores ]) ++ "\n"
          | c in Centers ])
];