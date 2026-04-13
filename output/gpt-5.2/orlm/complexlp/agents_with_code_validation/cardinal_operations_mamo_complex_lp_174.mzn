% Capacitated Facility Location / Transportation with fixed opening costs
% Data embedded as requested.

int: nCenters = 8;
int: nStores  = 5;

set of int: Centers = 1..nCenters;
set of int: Stores  = 1..nStores;

array[Centers] of int: openCost =
  [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

array[Centers] of int: capacity =
  [1308, 1575, 834, 1005, 1904, 1825, 1821, 1365];

array[Stores] of int: demand =
  [964, 739, 491, 766, 854];

array[Centers, Stores] of int: shipCost =
  [| 3, 3, 5, 4, 3
   | 5, 2, 4, 2, 4
   | 5, 1, 4, 2, 5
   | 4, 1, 1, 3, 3
   | 2, 4, 4, 3, 4
   | 4, 1, 3, 5, 3
   | 5, 1, 2, 4, 1
   | 4, 2, 2, 1, 2
  |];

% Use tight variable bounds to avoid timeout (previous model used totalDemand upper bound everywhere).
array[Centers, Stores] of int: shipUB =
  array2d(Centers, Stores, [ min(capacity[c], demand[s]) | c in Centers, s in Stores ]);

% Decision variables
array[Centers] of var bool: open;
array[Centers, Stores] of var int: ship;

% Domains (tight bounds)
constraint forall(c in Centers, s in Stores)(
  ship[c,s] >= 0 /\ ship[c,s] <= shipUB[c,s]
);

% Demand fulfillment: meet each store demand exactly
constraint forall(s in Stores)(
  sum(c in Centers)(ship[c,s]) = demand[s]
);

% Capacity + opening link: can only ship if open, and within capacity
constraint forall(c in Centers)(
  sum(s in Stores)(ship[c,s]) <= capacity[c] * bool2int(open[c])
);

% Objective: minimize fixed opening + variable shipping costs
var int: totalCost =
  sum(c in Centers)(openCost[c] * bool2int(open[c])) +
  sum(c in Centers, s in Stores)(shipCost[c,s] * ship[c,s]);

solve minimize totalCost;

output [
  "totalCost = ", show(totalCost), "\n",
  "open = ", show([bool2int(open[c]) | c in Centers]), "\n",
  "ship =\n"
] ++
[
  if s = 1 then "" else "" endif ++
  concat([ show(ship[c,s]) ++ if c = nCenters then "\n" else " " endif | c in Centers ])
  | s in Stores
];