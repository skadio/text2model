include "globals.mzn";

% WareCo facility location / transportation with capacities (7 centers, 7 stores)
int: C = 7; % distribution centers
int: S = 7; % retail stores

set of int: CENTERS = 1..C;
set of int: STORES  = 1..S;

array[CENTERS] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000];

array[CENTERS, STORES] of int: shipCost =
 [| 3, 3, 5, 4, 3, 5, 2
  | 4, 2, 4, 5, 1, 4, 2
  | 5, 4, 1, 1, 3, 3, 2
  | 4, 4, 3, 4, 4, 1, 3
  | 5, 3, 5, 1, 2, 4, 1
  | 4, 2, 2, 1, 2, 5, 2
  | 4, 4, 4, 4, 5, 3, 1 |];

array[STORES] of int: demand = [961, 787, 401, 789, 965, 505, 876];
array[CENTERS] of int: capacity = [1502, 1201, 1529, 961, 1001, 1795, 1069];

% Decision variables
array[CENTERS] of var 0..1: open;                         % 1 if center is opened
array[CENTERS, STORES] of var 0..max(demand): flow;       % units shipped i->j

% Constraints
% Each store's demand must be met exactly
constraint forall(j in STORES)(
  sum(i in CENTERS)(flow[i,j]) = demand[j]
);

% Capacity constraints (and linking to open: if not open then no flow)
constraint forall(i in CENTERS)(
  sum(j in STORES)(flow[i,j]) <= capacity[i] * open[i]
);

% Objective: opening + transportation costs
var int: totalOpenCost = sum(i in CENTERS)(openCost[i] * open[i]);
var int: totalShipCost = sum(i in CENTERS, j in STORES)(shipCost[i,j] * flow[i,j]);
var int: totalCost = totalOpenCost + totalShipCost;

solve minimize totalCost;

output [
  "Open = ", show(open), "\n",
  "Total opening cost = ", show(totalOpenCost), "\n",
  "Total shipping cost = ", show(totalShipCost), "\n",
  "Total cost = ", show(totalCost), "\n",
  "Flow (rows=centers, cols=stores) =\n", show(flow), "\n"
];