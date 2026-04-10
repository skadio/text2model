% Parameters (with values embedded)
int: I = 7; % distribution centers
int: J = 9; % retail stores

set of int: Centers = 1..I;
set of int: Stores  = 1..J;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000];

% Supply capacities (units)
array[Centers] of int: capacity = [814, 1962, 1017, 1538, 1392, 1178, 1466];

% Store demands (units)
array[Stores] of int: demand = [440, 892, 688, 783, 521, 610, 705, 864, 559];

% Transportation costs per unit (dollars) from center i to store j
% (Integers in the stated range 1..5)
array[Centers, Stores] of int: transCost =
[
| 2, 4, 3, 5, 1, 2, 4, 3, 5
| 3, 2, 4, 1, 5, 3, 2, 4, 1
| 4, 3, 2, 4, 2, 5, 1, 3, 2
| 5, 1, 3, 2, 4, 1, 5, 2, 3
| 1, 5, 1, 3, 3, 2, 4, 5, 4
| 2, 3, 5, 5, 1, 4, 3, 1, 2
| 3, 2, 4, 2, 5, 3, 2, 4, 1
];

int: totalDemand = sum(j in Stores)(demand[j]);
int: maxCap = max(i in Centers)(capacity[i]);

% Variables
array[Centers] of var 0..1: open;                       % 1 if center i is opened
array[Centers, Stores] of var 0..totalDemand: ship;     % units shipped from i to j

% Constraints
% Demand satisfaction
constraint forall(j in Stores)(
  sum(i in Centers)(ship[i,j]) = demand[j]
);

% Capacity respected if opened
constraint forall(i in Centers)(
  sum(j in Stores)(ship[i,j]) <= capacity[i] * open[i]
);

% Tighten per-arc bounds: cannot ship more than store demand, nor more than center capacity
constraint forall(i in Centers, j in Stores)(
  ship[i,j] <= demand[j]
);
constraint forall(i in Centers, j in Stores)(
  ship[i,j] <= capacity[i]
);

% Objective
var int: totalCost =
  sum(i in Centers)(openCost[i] * open[i]) +
  sum(i in Centers, j in Stores)(transCost[i,j] * ship[i,j]);

solve minimize totalCost;

output [
  "Total cost = ", show(totalCost), "\n",
  "Open centers = ", show([open[i] | i in Centers]), "\n",
  "Shipments (rows=centers, cols=stores) =\n",
  show([ [ship[i,j] | j in Stores] | i in Centers ])
];