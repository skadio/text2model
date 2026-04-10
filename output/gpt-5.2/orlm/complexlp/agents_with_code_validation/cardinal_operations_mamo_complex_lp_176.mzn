% Facility location / distribution center opening with shipping quantities

% Parameters
int: nCenters = 7;
int: nStores  = 5;

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost =
  [151000, 192000, 114000, 171000, 160000, 120000, 182000];

array[CENTERS] of int: capacity =
  [1697, 891, 1755, 1308, 1575, 834, 1005];

array[STORES] of int: demand =
  [715, 413, 641, 745, 964];

% Transportation cost per unit ($/unit)
% (Use array2d to avoid the row-separator '|' parsing issue)
array[CENTERS, STORES] of int: transCost =
  array2d(CENTERS, STORES,
    [ 3, 3, 5, 4, 3,
      5, 2, 4, 2, 4,
      5, 1, 4, 2, 5,
      4, 1, 1, 3, 3,
      2, 4, 4, 3, 4,
      4, 1, 3, 5, 3,
      5, 1, 2, 4, 1
    ]);

int: totalDemand = sum(s in STORES)(demand[s]);
int: maxTransCost = max([transCost[c,s] | c in CENTERS, s in STORES]);
int: ubTotalCost = sum(c in CENTERS)(openCost[c]) + totalDemand * maxTransCost;

% Variables
array[CENTERS] of var 0..1: open;                 % 1 if center opened
array[CENTERS, STORES] of var 0..totalDemand: ship; % units shipped
var 0..ubTotalCost: totalCost;

% Constraints

% Meet each store's demand exactly
constraint forall(s in STORES)(
  sum(c in CENTERS)(ship[c,s]) = demand[s]
);

% Respect capacity only if opened
constraint forall(c in CENTERS)(
  sum(s in STORES)(ship[c,s]) <= capacity[c] * open[c]
);

% Total cost = opening + transportation
constraint totalCost =
  sum(c in CENTERS)(openCost[c] * open[c]) +
  sum(c in CENTERS, s in STORES)(transCost[c,s] * ship[c,s]);

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show(open), "\n",
  "ship=\n", show(ship), "\n"
];