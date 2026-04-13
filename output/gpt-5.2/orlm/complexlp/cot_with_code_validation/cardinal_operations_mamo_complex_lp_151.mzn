% GlobalSupply Inc. - Facility location with capacities (embedded data)
% Objective type requested: satisfaction (find any feasible plan)

int: N = 5; % distribution centers
int: M = 6; % retail stores

array[1..N] of int: openCost = [151000, 192000, 114000, 171000, 160000];
array[1..N] of int: capacity  = [1400, 1115, 813, 1041, 1576];
array[1..M] of int: demand    = [530, 884, 420, 566, 673, 787];

array[1..N, 1..M] of int: transCost =
  [| 5, 2, 3, 3, 3, 5
   | 4, 3, 5, 2, 4, 2
   | 4, 5, 1, 4, 2, 5
   | 4, 1, 1, 3, 3, 2
   | 4, 4, 3, 4, 4, 1 |];

int: maxCap = max(capacity);

% Decision variables
array[1..N] of var bool: open;
array[1..N, 1..M] of var 0..maxCap: ship;

% Demand must be met exactly
constraint forall(j in 1..M) (
  sum(i in 1..N)(ship[i,j]) = demand[j]
);

% Shipments limited by capacity if opened (otherwise must be 0)
constraint forall(i in 1..N) (
  sum(j in 1..M)(ship[i,j]) <= capacity[i] * bool2int(open[i])
);

% (Optional) cost expressions, kept for reporting (no optimization requested)
var int: totalOpenCost = sum(i in 1..N)(openCost[i] * bool2int(open[i]));
var int: totalTransCost = sum(i in 1..N, j in 1..M)(transCost[i,j] * ship[i,j]);
var int: totalCost = totalOpenCost + totalTransCost;

solve satisfy;

output [
  "open = ", show(open), "\n",
  "ship =\n",
  concat([ concat([ show(ship[i,j]) ++ if j = M then "\n" else " " endif | j in 1..M ]) | i in 1..N ]),
  "totalOpenCost = ", show(totalOpenCost), "\n",
  "totalTransCost = ", show(totalTransCost), "\n",
  "totalCost = ", show(totalCost), "\n"
];