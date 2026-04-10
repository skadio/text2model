% Capacitated Facility Location / Distribution Center Opening with Shipping
% All data embedded as requested.

int: F = 8; % facilities (distribution centers)
int: S = 5; % stores

set of int: FAC = 1..F;
set of int: STO = 1..S;

array[FAC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

array[FAC, STO] of int: shipCost = array2d(FAC, STO, [
  3,3,5,4,3,
  5,2,4,2,4,
  5,1,4,2,5,
  4,1,1,3,3,
  2,4,4,3,4,
  4,1,3,5,3,
  5,1,2,4,1,
  4,2,2,1,2
]);

array[STO] of int: demand = [964, 739, 491, 766, 854];

array[FAC] of int: capacity = [1308, 1575, 834, 1005, 1904, 1825, 1821, 1365];

% Decision variables
array[FAC] of var bool: open;
array[FAC, STO] of var int: x; % shipped units from facility i to store j

% Domains for shipment variables
constraint forall(i in FAC, j in STO) (
  x[i,j] >= 0 /\ x[i,j] <= demand[j]
);

% Each store demand must be met exactly
constraint forall(j in STO) (
  sum(i in FAC)(x[i,j]) = demand[j]
);

% Facility capacity if opened, otherwise no shipments
constraint forall(i in FAC) (
  sum(j in STO)(x[i,j]) <= capacity[i] * bool2int(open[i])
);

% Objective: opening + transportation
var int: totalOpen = sum(i in FAC)(openCost[i] * bool2int(open[i]));
var int: totalShip = sum(i in FAC, j in STO)(shipCost[i,j] * x[i,j]);
var int: totalCost = totalOpen + totalShip;

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "totalOpen=", show(totalOpen), "\n",
  "totalShip=", show(totalShip), "\n\n",
  "open=", show([bool2int(open[i]) | i in FAC]), "\n\n",
  "shipments (rows=facilities, cols=stores):\n",
  concat([ concat([ show(x[i,j]) ++ if j==S then "\n" else "\t" endif | j in STO]) | i in FAC ])
];