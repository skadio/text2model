% Parameters (with values embedded)
int: M = 8; % potential distribution centers
int: N = 5; % retail stores

set of int: Centers = 1..M;
set of int: Stores  = 1..N;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

array[Centers, Stores] of int: transCost =
[| 3, 3, 5, 4, 3
 | 5, 2, 4, 2, 4
 | 5, 1, 4, 2, 5
 | 4, 1, 1, 3, 3
 | 2, 4, 4, 3, 4
 | 4, 1, 3, 5, 3
 | 5, 1, 2, 4, 1
 | 4, 2, 2, 1, 2 |];

array[Stores] of int: demand = [964, 739, 491, 766, 854];
array[Centers] of int: capacity = [1308, 1575, 834, 1005, 1904, 1825, 1821, 1365];

int: totalDemand = sum(s in Stores)(demand[s]);

% Variables
array[Centers] of var 0..1: open;
array[Centers, Stores] of var 0..totalDemand: flow;

% Constraints
constraint
  forall(s in Stores)(
    sum(c in Centers)(flow[c,s]) = demand[s]
  );

constraint
  forall(c in Centers)(
    sum(s in Stores)(flow[c,s]) <= capacity[c] * open[c]
  );

% Objective
var int: totalCost =
  sum(c in Centers)(openCost[c] * open[c]) +
  sum(c in Centers, s in Stores)(transCost[c,s] * flow[c,s]);

solve minimize totalCost;

output [
  "Optimal total cost = ", show(totalCost), "\n",
  "Opened centers (1=open): ", show(open), "\n",
  "Flows (center x store):\n", show(flow), "\n"
];