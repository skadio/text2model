% Parameters (with values embedded)
int: M = 4; % distribution centers
int: N = 4; % retail stores

set of int: Centers = 1..M;
set of int: Stores  = 1..N;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000];

array[Centers, Stores] of int: shipCost =
[| 5, 5, 2, 3
 | 3, 3, 5, 4
 | 3, 5, 2, 4
 | 2, 4, 5, 1 |];

array[Stores] of int: demand = [859, 713, 421, 652];
array[Centers] of int: capacity = [1547, 1656, 1274, 1882];

int: totalDemand = sum(s in Stores)(demand[s]);

% Variables
array[Centers] of var 0..1: open;
array[Centers, Stores] of var 0..totalDemand: x; % shipped units

var int: total_cost;

% Constraints
constraint
  forall(s in Stores)(
    sum(c in Centers)(x[c,s]) = demand[s]
  );

constraint
  forall(c in Centers)(
    sum(s in Stores)(x[c,s]) <= capacity[c] * open[c]
  );

% Objective
constraint total_cost =
  sum(c in Centers)(openCost[c] * open[c]) +
  sum(c in Centers, s in Stores)(shipCost[c,s] * x[c,s]);

solve minimize total_cost;

output [
  "Optimal total cost = ", show(total_cost), "\n",
  "Open centers (1=open): ", show(open), "\n",
  "Shipments x[c,s]:\n",
  concat([ "Center " ++ show(c) ++ ": " ++ show([x[c,s] | s in Stores]) ++ "\n" | c in Centers ])
];