% Facility location / transportation (capacitated) model
% Data embedded as requested.

int: nCenters = 6;
int: nStores  = 8;

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost =
  [151000, 192000, 114000, 171000, 160000, 120000];

array[CENTERS] of int: capacity =
  [1365, 1929, 1502, 1201, 1529, 961];

array[STORES] of int: demand =
  [908, 434, 605, 480, 961, 787, 401, 789];

array[CENTERS, STORES] of int: transCost =
  [| 2, 3, 1, 4, 3, 2, 4, 5
   | 2, 4, 2, 1, 3, 5, 4, 2
   | 5, 4, 3, 2, 1, 2, 3, 4
   | 4, 3, 2, 1, 2, 3, 4, 3
   | 5, 1, 2, 3, 4, 5, 3, 2
   | 1, 2, 3, 4, 5, 2, 1, 4 |];

int: totalDemand = sum(s in STORES)(demand[s]);

% Decision variables
array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var 0..totalDemand: ship;

% Constraints

% Each store demand must be met
constraint forall(s in STORES) (
  sum(c in CENTERS)(ship[c,s]) = demand[s]
);

% Capacity only if opened
constraint forall(c in CENTERS) (
  sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
);

% Objective
var int: totalCost =
    sum(c in CENTERS)(openCost[c] * bool2int(open[c]))
  + sum(c in CENTERS, s in STORES)(transCost[c,s] * ship[c,s]);

solve :: int_search([ship[c,s] | c in CENTERS, s in STORES] ++ [bool2int(open[c]) | c in CENTERS],
                    first_fail, indomain_min, complete)
minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show([open[c] | c in CENTERS]), "\n"
];