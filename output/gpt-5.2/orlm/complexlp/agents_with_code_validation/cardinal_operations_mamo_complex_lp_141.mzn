include "globals.mzn";

%-------------------------------
% Data (embedded)
%-------------------------------
int: nCenters = 4;
int: nStores  = 6;

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost = [151000, 192000, 114000, 171000];

array[CENTERS, STORES] of int: transCost =
  array2d(CENTERS, STORES,
    [ 5, 5, 2, 3, 3, 3,
      5, 4, 3, 5, 2, 4,
      2, 4, 5, 1, 4, 2,
      5, 4, 1, 1, 3, 3 ]);

array[STORES] of int: demand   = [910, 875, 589, 962, 966, 643];
array[CENTERS] of int: capacity = [1631, 1954, 1446, 820];

%-------------------------------
% Decision variables
%-------------------------------
array[CENTERS] of var bool: open;

% Shipments are bounded to keep the solver tight and avoid timeout
array[CENTERS, STORES] of var 0..max(demand): ship;

%-------------------------------
% Constraints
%-------------------------------

% Demand satisfaction
constraint forall(s in STORES) (
  sum(c in CENTERS)(ship[c,s]) = demand[s]
);

% Capacity and opening linkage
constraint forall(c in CENTERS) (
  sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
);

% Strengthening: if a center is open, it must ship at least 1 unit (avoid symmetry/useless opens)
constraint forall(c in CENTERS) (
  sum(s in STORES)(ship[c,s]) >= bool2int(open[c])
);

% At least enough capacity must be opened to cover total demand (useful propagation)
int: totalDemand = sum(s in STORES)(demand[s]);
constraint sum(c in CENTERS)(capacity[c] * bool2int(open[c])) >= totalDemand;

%-------------------------------
% Objective
%-------------------------------
var int: totalCost =
  sum(c in CENTERS)(openCost[c] * bool2int(open[c])) +
  sum(c in CENTERS, s in STORES)(transCost[c,s] * ship[c,s]);

solve minimize totalCost;

%-------------------------------
% Output
%-------------------------------
output [
  "totalCost=", show(totalCost), "\n",
  "open=", show(open), "\n"
];