int: F = 4;
int: S = 6;

set of int: Facilities = 1..F;
set of int: Stores = 1..S;

array[Facilities] of int: openCost = [151000, 192000, 114000, 171000];

array[Facilities, Stores] of int: shipCost = array2d(Facilities, Stores,
[
  5, 5, 2, 3, 3, 3,
  5, 4, 3, 5, 2, 4,
  2, 4, 5, 1, 4, 2,
  5, 4, 1, 1, 3, 3
]);

array[Stores] of int: demand = [910, 875, 589, 962, 966, 643];
array[Facilities] of int: capacity = [1631, 1954, 1446, 820];

int: totalDemand = sum(Stores)(demand[s]);

array[Facilities] of var bool: open;
array[Facilities, Stores] of var 0..totalDemand: x; % shipped units

constraint
  forall(s in Stores)(
    sum(f in Facilities)(x[f,s]) = demand[s]
  );

constraint
  forall(f in Facilities)(
    sum(s in Stores)(x[f,s]) <= capacity[f] * bool2int(open[f])
  );

var int: totalCost =
  sum(f in Facilities)(openCost[f] * bool2int(open[f])) +
  sum(f in Facilities, s in Stores)(shipCost[f,s] * x[f,s]);

solve minimize totalCost;

output [
  "Optimal total cost = ", show(totalCost), "\n",
  "Open centers: ", show([ bool2int(open[f]) | f in Facilities ]), "\n",
  "Shipment matrix x[f,s] (rows=facilities, cols=stores):\n",
  concat([ concat([ show(x[f,s]) ++ if s==S then "\n" else "\t" endif | s in Stores ]) | f in Facilities ])
];