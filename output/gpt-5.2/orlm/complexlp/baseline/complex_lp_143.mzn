% Facility Location / Distribution Network Design
% All data embedded. Objective: minimize opening + transportation costs
% Decision: which centers to open and shipment quantities to stores.

int: I = 6; % distribution centers
int: J = 8; % retail stores

set of int: Centers = 1..I;
set of int: Stores  = 1..J;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];

array[Centers, Stores] of int: shipCost =
[| 2, 3, 3, 3, 5, 4, 3, 5
 | 2, 4, 2, 4, 5, 1, 4, 2
 | 5, 4, 1, 1, 3, 3, 2, 4
 | 4, 3, 4, 4, 1, 3, 5, 3
 | 5, 1, 2, 4, 1, 4, 2, 2
 | 1, 2, 5, 2, 4, 4, 4, 4 |];

array[Stores] of int: demand = [908, 434, 605, 480, 961, 787, 401, 789];

array[Centers] of int: capacity = [1365, 1929, 1502, 1201, 1529, 961];

int: totalDemand = sum(Stores)(demand[j]);
int: maxCap = max(Centers)(capacity[i]);

array[Centers] of var bool: open;
array[Centers, Stores] of var 0..maxCap: x; % shipped units from center i to store j

% Demand satisfaction: each store demand must be met exactly
constraint forall(j in Stores)(
  sum(i in Centers)(x[i,j]) = demand[j]
);

% Capacity and opening linkage
constraint forall(i in Centers)(
  sum(j in Stores)(x[i,j]) <= capacity[i] * bool2int(open[i])
);

% Objective: opening cost + transportation cost
var int: totalCost =
  sum(i in Centers)(openCost[i] * bool2int(open[i])) +
  sum(i in Centers, j in Stores)(shipCost[i,j] * x[i,j]);

solve minimize totalCost;

output [
  "Optimal total cost = ", show(totalCost), "\n",
  "Open centers: ", show([i | i in Centers where fix(open[i]) = true]), "\n",
  "Shipments x[i,j] (rows centers, cols stores):\n",
  concat([ concat([ show(x[i,j]) ++ if j==J then "\n" else "\t" endif
                  | j in Stores ])
          | i in Centers ])
];