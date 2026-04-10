% Parameters (with values embedded)
int: M = 5; % potential distribution centers
int: N = 7; % retail stores

array[1..M] of int: openCost = [151000, 192000, 114000, 171000, 160000];

array[1..M, 1..N] of int: transCost =
[
 | 5, 2, 3, 3, 3, 5, 4
  | 3, 5, 2, 4, 2, 4, 5
  | 1, 4, 2, 5, 4, 1, 1
  | 3, 3, 2, 4, 4, 3, 4
  | 4, 1, 3, 5, 3, 5, 1
];

array[1..N] of int: demand = [566, 673, 787, 1000, 715, 413, 641];
array[1..M] of int: capacity = [1576, 1364, 1697, 891, 1755];

int: totalDemand = sum(j in 1..N)(demand[j]);
int: maxCap = max(i in 1..M)(capacity[i]);

% Variables
array[1..M] of var bool: open;                         % whether center i is opened
array[1..M, 1..N] of var 0..totalDemand: ship;         % units shipped from i to j

var 0..(sum(i in 1..M)(openCost[i]) + totalDemand * max(i in 1..M, j in 1..N)(transCost[i,j])): totalCost;

% Constraints
constraint
  forall(j in 1..N)(
    sum(i in 1..M)(ship[i,j]) = demand[j]
  );

constraint
  forall(i in 1..M)(
    sum(j in 1..N)(ship[i,j]) <= capacity[i] * bool2int(open[i])
  );

% Objective
constraint
  totalCost =
    sum(i in 1..M)(openCost[i] * bool2int(open[i])) +
    sum(i in 1..M, j in 1..N)(transCost[i,j] * ship[i,j]);

solve minimize totalCost;

output [
  "Total cost = ", show(totalCost), "\n",
  "Open centers (1=open,0=closed): ", show([bool2int(open[i]) | i in 1..M]), "\n",
  "Shipments (rows=centers, cols=stores):\n",
  concat([ concat([ show(ship[i,j]) ++ if j==N then "\n" else "\t" endif | j in 1..N ]) | i in 1..M ])
];