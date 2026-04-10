% Facility location / transportation model for LogistiCorp
% All data embedded as requested.

%-----------------------
% Parameters / Data
%-----------------------
int: nCenters = 7;
int: nStores  = 9;

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost =
  [151000, 192000, 114000, 171000, 160000, 120000, 182000];

array[CENTERS] of int: capacity =
  [814, 864, 1320, 1952, 1447, 1886, 1962];

array[STORES] of int: demand =
  [695, 737, 452, 616, 587, 779, 892, 440, 556];

% Per-unit transport cost center -> store
% Fix: provide a proper 2D array literal (array2d) instead of a flat 1D list.
array[CENTERS, STORES] of int: transCost =
  array2d(CENTERS, STORES, [
    3, 3, 5, 4, 3, 5, 2, 4, 2,   % Center 1
    4, 5, 1, 4, 2, 5, 4, 1, 1,   % Center 2
    3, 3, 2, 4, 4, 3, 4, 4, 1,   % Center 3
    3, 5, 3, 5, 1, 2, 4, 1, 4,   % Center 4
    2, 2, 1, 2, 5, 2, 4, 4, 4,   % Center 5
    4, 5, 3, 1, 4, 2, 4, 2, 2,   % Center 6
    4, 5, 2, 2, 4, 2, 2, 4, 4    % Center 7
  ]);

int: maxShip = max(capacity);

%-----------------------
% Decision Variables
%-----------------------
array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var 0..maxShip: ship;

var int: totalOpenCost;
var int: totalTransCost;
var int: totalCost;

%-----------------------
% Constraints
%-----------------------

% Demand satisfaction (each store must receive exactly its demand)
constraint forall(s in STORES) (
  sum(c in CENTERS)(ship[c,s]) = demand[s]
);

% Capacity and opening linkage
constraint forall(c in CENTERS) (
  sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
);

% Cost definitions
constraint totalOpenCost = sum(c in CENTERS)(openCost[c] * bool2int(open[c]));
constraint totalTransCost = sum(c in CENTERS, s in STORES)(transCost[c,s] * ship[c,s]);
constraint totalCost = totalOpenCost + totalTransCost;

%-----------------------
% Objective
%-----------------------
solve minimize totalCost;

% (Optional) output
output [
  "totalCost=", show(totalCost), "\n",
  "totalOpenCost=", show(totalOpenCost), "\n",
  "totalTransCost=", show(totalTransCost), "\n",
  "open=", show(open), "\n"
];