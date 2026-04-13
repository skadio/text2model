% Facility Location + Transportation (Capacitated) - all data embedded
include "globals.mzn";

int: F = 6;  % facilities / distribution centers
int: S = 9;  % stores

set of int: FAC = 1..F;
set of int: STO = 1..S;

array[FAC] of int: openCost = [
  151000, 192000, 114000, 171000, 160000, 120000
];

array[STO] of int: demand = [
  401, 789, 965, 505, 876, 801, 955, 561, 601
];

array[FAC] of int: capacity = [
  1795, 1069, 1615, 1255, 1816, 1095
];

% Transportation cost per unit (facility i -> store j)
array[FAC, STO] of int: tCost = array2d(FAC, STO, [
  % Center 1 -> Stores 1..9
  2, 3, 1, 4, 2, 5, 3, 4, 2,
  % Center 2
  4, 2, 3, 2, 4, 3, 5, 3, 4,
  % Center 3
  3, 4, 2, 5, 3, 2, 4, 2, 3,
  % Center 4
  5, 3, 4, 2, 5, 4, 2, 3, 4,
  % Center 5
  2, 5, 3, 4, 2, 3, 4, 5, 2,
  % Center 6
  4, 3, 5, 3, 4, 2, 3, 4, 3
]);

% Decision variables
array[FAC] of var 0..1: open;                          % 1 if center is opened
array[FAC, STO] of var 0..max(demand): ship;           % units shipped i->j

% Demand satisfaction: each store demand must be met exactly
constraint forall(j in STO)(
  sum(i in FAC)(ship[i,j]) = demand[j]
);

% Capacity and linking: can only ship if facility is open, and within capacity
constraint forall(i in FAC)(
  sum(j in STO)(ship[i,j]) <= capacity[i] * open[i]
);

% Objective: opening + transportation
var int: totalOpenCost = sum(i in FAC)(openCost[i] * open[i]);
var int: totalTransCost = sum(i in FAC, j in STO)(tCost[i,j] * ship[i,j]);
var int: totalCost = totalOpenCost + totalTransCost;

solve minimize totalCost;

output [
  "Total cost = ", show(totalCost), "\n",
  "  Opening cost = ", show(totalOpenCost), "\n",
  "  Transport cost = ", show(totalTransCost), "\n\n",
  "Open centers (1=open): ", show(open), "\n\n",
  "Shipments (rows=centers 1..6, cols=stores 1..9):\n",
  concat([ concat([ if j=1 then "" else " " endif ++ show(ship[i,j]) | j in STO ]) ++ "\n" | i in FAC ])
];