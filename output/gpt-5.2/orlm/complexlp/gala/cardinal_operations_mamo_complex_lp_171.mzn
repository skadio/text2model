include "globals.mzn";

% Capacitated facility location / transportation with fixed opening costs
int: m = 6; % distribution centers
int: n = 7; % retail stores

set of int: C = 1..m;
set of int: S = 1..n;

array[C] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];

array[C,S] of int: shipCost =
 [| 2,3,3,3,5,4,3
  | 5,2,4,2,4,5,1
  | 4,2,5,4,1,1,3
  | 3,2,4,4,3,4,4
  | 1,3,5,3,5,1,2
  | 4,1,4,2,2,1,2
  |];

array[S] of int: demand = [964,739,491,766,854,827,908];
array[C] of int: capacity = [1575,834,1005,1904,1825,1821];

% Decision variables
array[C] of var 0..1: open;                 % 1 if center is opened
array[C,S] of var 0..max(demand): x;        % units shipped from center c to store s

% Demand satisfaction
constraint forall(s in S)(
  sum(c in C)(x[c,s]) = demand[s]
);

% Capacity constraints + linking to opening decision
constraint forall(c in C)(
  sum(s in S)(x[c,s]) <= capacity[c] * open[c]
);

% Objective: fixed opening + variable shipping
var int: totalCost =
  sum(c in C)(openCost[c] * open[c]) +
  sum(c in C, s in S)(shipCost[c,s] * x[c,s]);

solve minimize totalCost;

output [
  "Total cost = ", show(totalCost), "\n",
  "Open centers (1=open): ", show(open), "\n",
  "Shipments x[c,s] (rows centers, cols stores):\n",
  show([ [ x[c,s] | s in S ] | c in C ]), "\n"
];