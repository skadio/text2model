% Facility location / distribution planning (embedded data)

int: nCenters = 4;
int: nOutlets = 4;

set of int: Centers = 1..nCenters;
set of int: Outlets = 1..nOutlets;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000];

array[Centers, Outlets] of int: transCost =
  [| 5, 5, 2, 3
   | 3, 3, 5, 4
   | 3, 5, 2, 4
   | 2, 4, 5, 1 |];

array[Outlets] of int: demand = [859, 713, 421, 652];
array[Centers] of int: capacity = [1547, 1656, 1274, 1882];

int: totalDemand = sum(o in Outlets)(demand[o]);

array[Centers] of var bool: open;

% Shipments (units) from center c to outlet o
array[Centers, Outlets] of var 0..totalDemand: x;

% Demand satisfaction
constraint forall(o in Outlets)(
  sum(c in Centers)(x[c,o]) = demand[o]
);

% Capacity only if the center is open
constraint forall(c in Centers)(
  sum(o in Outlets)(x[c,o]) <= capacity[c] * bool2int(open[c])
);

var int: totalCost =
  sum(c in Centers)(openCost[c] * bool2int(open[c])) +
  sum(c in Centers, o in Outlets)(transCost[c,o] * x[c,o]);

solve minimize totalCost;

output [
  "Optimal total cost = ", show(totalCost), "\n",
  "Open centers = ", show([bool2int(open[c]) | c in Centers]), "\n",
  "Shipments x[c,o]:\n"
] ++
[
  "Center " ++ show(c) ++ ": " ++ show([x[c,o] | o in Outlets]) ++ "\n"
  | c in Centers
];