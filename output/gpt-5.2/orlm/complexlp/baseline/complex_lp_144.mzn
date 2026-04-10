% Facility location / transportation with fixed opening costs
% Data embedded as requested.

int: F = 4; % distribution centers
int: S = 8; % retail stores

set of int: Centers = 1..F;
set of int: Stores  = 1..S;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000];

array[Centers, Stores] of int: shipCost =
  [| 5, 5, 2, 3, 3, 3, 5, 4
   | 3, 5, 2, 4, 2, 4, 5, 1
   | 4, 2, 5, 4, 1, 1, 3, 3
   | 2, 4, 4, 3, 4, 4, 1, 3 |];

array[Stores] of int: demand = [884, 420, 566, 673, 787, 1000, 715, 413];
array[Centers] of int: capacity = [1041, 1576, 1364, 1697];

int: totalDemand = sum(Stores)(demand[s]);
int: maxShip = totalDemand;

array[Centers] of var 0..1: open;
array[Centers, Stores] of var 0..maxShip: x; % units shipped from center i to store s

% Demand satisfaction
constraint forall(s in Stores) (
  sum(i in Centers)(x[i,s]) = demand[s]
);

% Capacity only if opened
constraint forall(i in Centers) (
  sum(s in Stores)(x[i,s]) <= capacity[i] * open[i]
);

var int: totalCost =
  sum(i in Centers)(openCost[i] * open[i]) +
  sum(i in Centers, s in Stores)(shipCost[i,s] * x[i,s]);

solve minimize totalCost;

output [
  "Optimal total cost = ", show(totalCost), "\n",
  "Open centers (1=yes,0=no): ", show([open[i] | i in Centers]), "\n",
  "Shipments x[i,s]:\n"
] ++
[
  "Center " ++ show(i) ++ ": " ++ show([x[i,s] | s in Stores]) ++ "\n"
  | i in Centers
];