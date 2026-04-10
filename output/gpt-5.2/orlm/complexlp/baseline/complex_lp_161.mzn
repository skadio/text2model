% Facility location / capacitated distribution with shipping quantities
% All data embedded as requested.

int: F = 5; % potential distribution centers
int: S = 7; % retail stores

set of int: FACILITIES = 1..F;
set of int: STORES = 1..S;

array[FACILITIES] of int: openCost = [151000, 192000, 114000, 171000, 160000];

array[FACILITIES, STORES] of int: shipCost =
[
  % store1 store2 store3 store4 store5 store6 store7
  |   5,     2,     3,     3,     3,     5,     4  % center 1
  |   3,     5,     2,     4,     2,     4,     5  % center 2
  |   1,     4,     2,     5,     4,     1,     1  % center 3
  |   3,     3,     2,     4,     4,     3,     4  % center 4
  |   4,     1,     3,     5,     3,     5,     1  % center 5
];

array[STORES] of int: demand = [566, 673, 787, 1000, 715, 413, 641];

array[FACILITIES] of int: capacity = [1576, 1364, 1697, 891, 1755];

% Decision variables
array[FACILITIES] of var bool: open;
array[FACILITIES, STORES] of var 0..max(demand): x; % units shipped from facility i to store j

% Demand satisfaction
constraint forall(j in STORES)(
  sum(i in FACILITIES)(x[i,j]) = demand[j]
);

% Capacity constraints (only if open)
constraint forall(i in FACILITIES)(
  sum(j in STORES)(x[i,j]) <= capacity[i] * bool2int(open[i])
);

% Objective: opening + transportation costs
var int: totalOpenCost = sum(i in FACILITIES)(openCost[i] * bool2int(open[i]));
var int: totalShipCost = sum(i in FACILITIES, j in STORES)(shipCost[i,j] * x[i,j]);
var int: totalCost = totalOpenCost + totalShipCost;

solve minimize totalCost;

output [
  "Total cost = ", show(totalCost), "\n",
  "  Opening cost = ", show(totalOpenCost), "\n",
  "  Shipping cost = ", show(totalShipCost), "\n\n",
  "Open centers:\n",
  concat([ "  Center ", show(i), ": ", show(open[i]), "\n" | i in FACILITIES ]),
  "\nShipments x[i,j]:\n",
  concat([
    "  Center " ++ show(i) ++ ": " ++
    concat([ (if j=1 then "" else " " endif) ++ "S" ++ show(j) ++ "=" ++ show(x[i,j]) | j in STORES ]) ++ "\n"
    | i in FACILITIES
  ])
];