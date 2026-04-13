% SupplyTek Distribution Network Optimization (Facility Location + Transportation)
% All data embedded directly in the model.

int: C = 7; % centers
int: S = 4; % stores
set of int: CENTERS = 1..C;
set of int: STORES  = 1..S;

array[CENTERS] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000];

array[CENTERS, STORES] of int: transCost =
[
  % s1 s2 s3 s4
  |  3,  3,  5,  4  % center 1
  |  3,  5,  2,  4  % center 2
  |  2,  4,  5,  1  % center 3
  |  4,  2,  5,  4  % center 4
  |  1,  1,  3,  3  % center 5
  |  2,  4,  4,  3  % center 6
  |  4,  4,  1,  3  % center 7
];

array[STORES] of int: demand = [884, 420, 566, 673];
array[CENTERS] of int: capacity = [1187, 1400, 1115, 813, 1041, 1576, 1364];

% Decision variables
array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var int: ship; % units shipped from center c to store s

% Bounds
constraint forall(c in CENTERS, s in STORES) (ship[c,s] >= 0);

% Meet each store's demand exactly
constraint forall(s in STORES)(
  sum(c in CENTERS)(ship[c,s]) = demand[s]
);

% Capacity constraints tied to opening decision
constraint forall(c in CENTERS)(
  sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
);

% Objective: opening + transportation
var int: totalCost =
  sum(c in CENTERS)(openCost[c] * bool2int(open[c])) +
  sum(c in CENTERS, s in STORES)(transCost[c,s] * ship[c,s]);

solve minimize totalCost;

output [
  "Minimum total cost = ", show(totalCost), "\n",
  "Open centers (1=yes,0=no): ", show([bool2int(open[c]) | c in CENTERS]), "\n",
  "Shipments (rows=centers, cols=stores):\n",
  concat([ concat([ show(ship[c,s]) ++ if s==S then "\n" else "\t" endif | s in STORES]) | c in CENTERS ])
];