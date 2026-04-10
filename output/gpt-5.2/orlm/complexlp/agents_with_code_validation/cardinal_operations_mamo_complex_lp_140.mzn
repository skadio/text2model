include "globals.mzn";

%----------------------------
% Data (embedded)
%----------------------------
int: nCenters = 7;
int: nStores  = 7;

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost =
  [151000, 192000, 114000, 171000, 160000, 120000, 182000];

array[CENTERS, STORES] of int: transCost =
  [| 3, 3, 5, 4, 3, 5, 2
   | 4, 2, 4, 5, 1, 4, 2
   | 5, 4, 1, 1, 3, 3, 2
   | 4, 4, 3, 4, 4, 1, 3
   | 5, 3, 5, 1, 2, 4, 1
   | 4, 2, 2, 1, 2, 5, 2
   | 4, 4, 4, 4, 5, 3, 1
  |];

array[STORES] of int: demand =
  [961, 787, 401, 789, 965, 505, 876];

array[CENTERS] of int: capacity =
  [1502, 1201, 1529, 961, 1001, 1795, 1069];

int: totalDemand = sum(s in STORES)(demand[s]);

% Tight big-M per (center,store): cannot ship more than store demand anyway
array[CENTERS, STORES] of int: M = array2d(CENTERS, STORES,
  [ min(capacity[c], demand[s]) | c in CENTERS, s in STORES ]
);

%----------------------------
% Decision variables
%----------------------------
array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var 0..totalDemand: ship;

%----------------------------
% Constraints
%----------------------------

% Ship only from open centers (use tighter M to improve solving speed)
constraint forall(c in CENTERS, s in STORES) (
  ship[c,s] <= M[c,s] * bool2int(open[c])
);

% Center capacity
constraint forall(c in CENTERS) (
  sum(s in STORES)(ship[c,s]) <= capacity[c]
);

% Meet each store's demand exactly
constraint forall(s in STORES) (
  sum(c in CENTERS)(ship[c,s]) = demand[s]
);

%----------------------------
% Objective
%----------------------------
var int: totalCost =
  sum(c in CENTERS)(openCost[c] * bool2int(open[c])) +
  sum(c in CENTERS, s in STORES)(transCost[c,s] * ship[c,s]);

solve minimize totalCost;

%----------------------------
% Output
%----------------------------
output [
  "totalCost=", show(totalCost), "\n",
  "open=", show([bool2int(open[c]) | c in CENTERS]), "\n"
];