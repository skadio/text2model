% Facility location / capacitated transportation with fixed opening costs
% Data embedded directly as requested.

int: F = 4;  % potential distribution centers
int: S = 8;  % retail stores

set of int: FAC = 1..F;
set of int: STO = 1..S;

array[FAC] of int: openCost = [151000, 192000, 114000, 171000];

array[FAC, STO] of int: shipCost =
[
  % store1 store2 store3 store4 store5 store6 store7 store8
  |   5,     5,     2,     3,     3,     3,     5,     4  % center 1
  |   3,     5,     2,     4,     2,     4,     5,     1  % center 2
  |   4,     2,     5,     4,     1,     1,     3,     3  % center 3
  |   2,     4,     4,     3,     4,     4,     1,     3  % center 4
];

array[STO] of int: demand = [884, 420, 566, 673, 787, 1000, 715, 413];
array[FAC] of int: capacity = [1041, 1576, 1364, 1697];

% Decision variables
array[FAC] of var bool: open;
array[FAC, STO] of var 0..max(demand): x; % units shipped from center i to store j

% Each store demand must be met exactly
constraint forall(j in STO)(
  sum(i in FAC)(x[i,j]) = demand[j]
);

% Capacity constraints and linking to opening decision
constraint forall(i in FAC)(
  sum(j in STO)(x[i,j]) <= capacity[i] * bool2int(open[i])
);

% Objective: opening costs + transportation costs
var int: totalCost =
  sum(i in FAC)(openCost[i] * bool2int(open[i])) +
  sum(i in FAC, j in STO)(shipCost[i,j] * x[i,j]);

solve minimize totalCost;

output [
  "Optimal total cost = ", show(totalCost), "\n",
  "Open centers: ", show([bool2int(open[i]) | i in FAC]), "\n",
  "Shipments x[i,j] (rows=center, cols=store):\n",
  concat([ concat([ show(x[i,j]) ++ if j==S then "\n" else "\t" endif
                   | j in STO ])
           | i in FAC ])
];