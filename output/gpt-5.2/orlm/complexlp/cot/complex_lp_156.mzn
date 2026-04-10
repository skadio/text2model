% Parameters (with values embedded)
int: nCenters = 7;
int: nStores  = 6;

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000];

array[CENTERS, STORES] of int: transCost =
  array2d(CENTERS, STORES,
    [ 3,3,5,4,3,5,
      2,4,2,4,5,1,
      4,2,5,4,1,1,
      3,3,2,4,4,3,
      4,4,1,3,5,3,
      5,1,2,4,1,4,
      2,2,1,2,5,2 ]);

array[STORES] of int: demand = [739, 491, 766, 854, 827, 908];

array[CENTERS] of int: capacity = [1575, 834, 1005, 1904, 1825, 1821, 1365];

int: totalDemand = sum(s in STORES)(demand[s]);
int: maxCap = max(c in CENTERS)(capacity[c]);

% Variables
array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var 0..maxCap: ship;

% Constraints
constraint
  forall(s in STORES)(
    sum(c in CENTERS)(ship[c,s]) = demand[s]
  );

constraint
  forall(c in CENTERS)(
    sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
  );

% Objective
var int: totalCost =
  sum(c in CENTERS)(openCost[c] * bool2int(open[c])) +
  sum(c in CENTERS, s in STORES)(transCost[c,s] * ship[c,s]);

solve minimize totalCost;

output [
  "Optimal total cost = ", show(totalCost), "\n",
  "Centers open: ", show([bool2int(open[c]) | c in CENTERS]), "\n",
  "Shipments (center x store):\n"
] ++
[
  "Center " ++ show(c) ++ ": " ++ show([ship[c,s] | s in STORES]) ++ "\n"
  | c in CENTERS
];