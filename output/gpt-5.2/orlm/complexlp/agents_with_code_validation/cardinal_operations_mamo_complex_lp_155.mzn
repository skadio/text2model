% Facility location / distribution planning (embedded data)

include "globals.mzn";

int: nCenters = 9;
int: nStores  = 5;

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost =
  [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000];

array[CENTERS, STORES] of int: transCost =
  array2d(CENTERS, STORES,
  [
    3, 5, 4, 3, 5,
    2, 4, 2, 4, 5,
    1, 4, 2, 5, 4,
    1, 1, 3, 3, 2,
    4, 4, 3, 4, 4,
    1, 3, 5, 3, 5,
    1, 2, 4, 1, 4,
    2, 2, 1, 2, 5,
    2, 4, 4, 4, 4
  ]);

array[STORES] of int: demand = [908, 434, 605, 480, 961];

array[CENTERS] of int: capacity =
  [1825, 1821, 1365, 1929, 1502, 1201, 1529, 961, 1001];

int: totalDemand = sum(s in STORES)(demand[s]);

% Use tight per-(c,s) upper bounds to avoid huge search and timeouts.
array[CENTERS, STORES] of int: shipUB =
  array2d(CENTERS, STORES, [ min(capacity[c], demand[s]) | c in CENTERS, s in STORES ]);

% Decision variables
array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var 0..totalDemand: ship;

% Enforce tight domains on ship variables (cannot declare var array with varying bounds directly)
constraint forall(c in CENTERS, s in STORES)(ship[c,s] <= shipUB[c,s]);

% Demand satisfaction
constraint forall(s in STORES)(
  sum(c in CENTERS)(ship[c,s]) == demand[s]
);

% Capacity only if open
constraint forall(c in CENTERS)(
  sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
);

% No shipments from closed centers (strengthening)
constraint forall(c in CENTERS, s in STORES)(
  ship[c,s] <= demand[s] * bool2int(open[c])
);

% Objective: opening + transportation
var int: totalCost =
  sum(c in CENTERS)(openCost[c] * bool2int(open[c])) +
  sum(c in CENTERS, s in STORES)(transCost[c,s] * ship[c,s]);

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show([bool2int(open[c]) | c in CENTERS]), "\n"
];