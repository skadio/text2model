int: I = 4;
int: J = 4;

set of int: Centers = 1..I;
set of int: Outlets = 1..J;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000];
array[Centers] of int: capacity = [1547, 1656, 1274, 1882];
array[Outlets] of int: demand = [859, 713, 421, 652];

array[Centers, Outlets] of int: shipCost =
  [| 5, 5, 2, 3
   | 3, 3, 5, 4
   | 3, 5, 2, 4
   | 2, 4, 5, 1 |];

int: totalDemand = sum(o in Outlets)(demand[o]);
int: maxUnitShipCost = max([shipCost[c,o] | c in Centers, o in Outlets]);

int: maxOpenCost = sum(c in Centers)(openCost[c]);
int: maxTotalShipCost = totalDemand * maxUnitShipCost;
int: maxTotalCost = maxOpenCost + maxTotalShipCost;

array[Centers] of var bool: open;
array[Centers, Outlets] of var 0..totalDemand: flow;

constraint forall(o in Outlets) (
  sum(c in Centers)(flow[c,o]) = demand[o]
);

constraint forall(c in Centers) (
  sum(o in Outlets)(flow[c,o]) <= capacity[c] * bool2int(open[c])
);

var 0..maxTotalCost: totalCost =
  sum(c in Centers)(openCost[c] * bool2int(open[c])) +
  sum(c in Centers, o in Outlets)(shipCost[c,o] * flow[c,o]);

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show([open[c] | c in Centers]), "\n",
  "flow=\n",
  concat([ concat([ show(flow[c,o]) ++ if o==J then "\n" else " " endif
                  | o in Outlets ])
         | c in Centers ])
];