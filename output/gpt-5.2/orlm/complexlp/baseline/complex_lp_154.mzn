% Facility location + transportation with capacities (uncapacitated assignment is not enough here)
% Minimize opening costs + per-unit transport costs*shipped units
% All data embedded.

int: F = 6; % facilities (distribution centers)
int: C = 8; % customers (stores)

set of int: FAC = 1..F;
set of int: CUST = 1..C;

array[FAC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];

% Transport cost per unit from facility i to customer j
array[FAC, CUST] of int: tCost =
[| 2, 3, 3, 4, 4, 3, 4, 5
 | 2, 4, 4, 3, 2, 5, 4, 2
 | 5, 4, 3, 2, 3, 3, 2, 4
 | 4, 3, 5, 3, 4, 2, 4, 3
 | 5, 1, 2, 4, 3, 5, 4, 2
 | 1, 2, 4, 5, 3, 2, 3, 4 |];

array[CUST] of int: demand = [908, 434, 605, 480, 961, 787, 401, 789];
array[FAC] of int: capacity = [1365, 1929, 1502, 1201, 1529, 961];

% Decision variables
array[FAC] of var bool: open;
array[FAC, CUST] of var 0..max(demand): ship; % units shipped from i to j

% Demand satisfaction
constraint forall(j in CUST)(
  sum(i in FAC)(ship[i,j]) = demand[j]
);

% Capacity and linking to opening decision
constraint forall(i in FAC)(
  sum(j in CUST)(ship[i,j]) <= capacity[i] * bool2int(open[i])
);

% Objective: opening + transportation
var int: totalCost =
  sum(i in FAC)(openCost[i] * bool2int(open[i])) +
  sum(i in FAC, j in CUST)(tCost[i,j] * ship[i,j]);

solve minimize totalCost;

output [
  "Optimal total cost = ", show(totalCost), "\n",
  "Open centers: ", show([i | i in FAC where fix(open[i]) = true]), "\n",
  "Shipments (facility x customer):\n"
] ++
[
  "Center " ++ show(i) ++ ": " ++ show([ship[i,j] | j in CUST]) ++ "\n"
  | i in FAC
];