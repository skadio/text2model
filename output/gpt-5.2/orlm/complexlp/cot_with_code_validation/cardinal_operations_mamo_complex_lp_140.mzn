% Facility location / distribution planning for WareCo

% Parameters
int: M = 7; % number of potential distribution centers
int: N = 7; % number of retail stores

set of int: Centers = 1..M;
set of int: Stores  = 1..N;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000];

array[Centers, Stores] of int: transCost =
  [| 3, 3, 5, 4, 3, 5, 2
   | 4, 2, 4, 5, 1, 4, 2
   | 5, 4, 1, 1, 3, 3, 2
   | 4, 4, 3, 4, 4, 1, 3
   | 5, 3, 5, 1, 2, 4, 1
   | 4, 2, 2, 1, 2, 5, 2
   | 4, 4, 4, 4, 5, 3, 1
  |];

array[Stores] of int: demand = [961, 787, 401, 789, 965, 505, 876];
array[Centers] of int: capacity = [1502, 1201, 1529, 961, 1001, 1795, 1069];

int: totalDemand = sum(j in Stores)(demand[j]);

% Variables
array[Centers] of var bool: open;
array[Centers, Stores] of var 0..totalDemand: ship;

% Constraints: satisfy demand
constraint forall(j in Stores) (
  sum(i in Centers)(ship[i,j]) = demand[j]
);

% Constraints: respect capacity if center is open
constraint forall(i in Centers) (
  sum(j in Stores)(ship[i,j]) <= capacity[i] * bool2int(open[i])
);

% Objective
var int: totalCost =
  sum(i in Centers)(openCost[i] * bool2int(open[i])) +
  sum(i in Centers, j in Stores)(transCost[i,j] * ship[i,j]);

solve minimize totalCost;

output
[
  "Total cost = ", show(totalCost), "\n",
  "Open centers (1=open): ", show([bool2int(open[i]) | i in Centers]), "\n",
  "Shipments (rows=centers, cols=stores):\n"
]
++
[
  concat([show(ship[i,j]) ++ if j < N then " " else "" endif | j in Stores]) ++ "\n"
  | i in Centers
];