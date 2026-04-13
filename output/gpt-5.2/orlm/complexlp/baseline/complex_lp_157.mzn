% Facility location with shipping amounts (capacitated)
% All data embedded.

int: nCenters = 6;
int: nStores  = 5;

set of int: Centers = 1..nCenters;
set of int: Stores  = 1..nStores;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];

array[Centers, Stores] of int: shipCost =
[
  | 2, 3, 3, 3, 5
  | 4, 3, 5, 2, 4
  | 2, 4, 5, 1, 4
  | 2, 5, 4, 1, 1
  | 3, 3, 2, 4, 4
  | 3, 4, 4, 1, 3
];

array[Stores] of int: demand = [884, 420, 566, 673, 787];
array[Centers] of int: capacity = [1400, 1115, 813, 1041, 1576, 1364];

int: totalDemand = sum(Stores)(demand[s]);

array[Centers] of var bool: open;
array[Centers, Stores] of var 0..totalDemand: ship;

% Demand satisfaction
constraint forall(s in Stores)(
  sum(c in Centers)(ship[c,s]) = demand[s]
);

% Capacity and linking to open decision
constraint forall(c in Centers)(
  sum(s in Stores)(ship[c,s]) <= capacity[c] * bool2int(open[c])
);

var int: totalOpenCost = sum(c in Centers)(openCost[c] * bool2int(open[c]));
var int: totalShipCost = sum(c in Centers, s in Stores)(shipCost[c,s] * ship[c,s]);
var int: totalCost = totalOpenCost + totalShipCost;

solve minimize totalCost;

output [
  "Total cost = ", show(totalCost), "\n",
  "Open cost  = ", show(totalOpenCost), "\n",
  "Ship cost  = ", show(totalShipCost), "\n\n",
  "Open centers:\n",
  concat([ "  Center " ++ show(c) ++ ": " ++ show(open[c]) ++ "\n" | c in Centers ]),
  "\nShipments (center -> store: units):\n",
  concat([ concat([ "  C"++show(c)++"->S"++show(s)++": "++show(ship[c,s])++"\n"
                    | s in Stores, fix(ship[c,s]) != 0 ]) | c in Centers ])
];