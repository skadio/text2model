% Facility Location / Capacitated Facility Location
% All data embedded as requested.

int: F = 5;   % potential distribution centers
int: S = 9;   % retail stores

set of int: Centers = 1..F;
set of int: Stores  = 1..S;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000];

array[Centers, Stores] of int: shipCost =
[
  % store: 1  2  3  4  5  6  7  8  9
  |   5, 2, 3, 3, 3, 5, 4, 3, 5   % center 1
  | , 2, 4, 2, 4, 5, 1, 4, 2, 5   % center 2
  | , 4, 1, 1, 3, 3, 2, 4, 4, 3   % center 3
  | , 4, 4, 1, 3, 5, 3, 5, 1, 2   % center 4
  | , 4, 1, 4, 2, 2, 1, 2, 5, 2   % center 5
];

array[Stores] of int: demand = [739, 491, 766, 854, 827, 908, 434, 605, 480];
array[Centers] of int: capacity = [1825, 1821, 1365, 1929, 1502];

% Decision variables
array[Centers] of var bool: open;
array[Centers, Stores] of var 0..max(demand): x; % units shipped from center i to store j

% Demand satisfaction
constraint forall(j in Stores) (
  sum(i in Centers)(x[i,j]) = demand[j]
);

% Capacity limits (only if opened)
constraint forall(i in Centers) (
  sum(j in Stores)(x[i,j]) <= capacity[i] * bool2int(open[i])
);

% Objective: opening + shipping
var int: totalCost =
  sum(i in Centers)(openCost[i] * bool2int(open[i])) +
  sum(i in Centers, j in Stores)(shipCost[i,j] * x[i,j]);

solve minimize totalCost;

output [
  "Total cost = ", show(totalCost), "\n",
  "Open centers = ", show([i | i in Centers where fix(open[i]) = 1]), "\n",
  "Open flags = ", show([bool2int(open[i]) | i in Centers]), "\n",
  "Shipments x[i,j] (rows=centers, cols=stores):\n",
  concat([ concat([ show(x[i,j]) ++ if j==S then "\n" else "\t" endif | j in Stores ])
         | i in Centers ])
];