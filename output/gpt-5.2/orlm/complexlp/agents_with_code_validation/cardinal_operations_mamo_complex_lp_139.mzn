% SupplyLink facility location + transportation (fixed-charge)
% Data embedded as requested.

int: nCenters = 5;
int: nStores  = 5;

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost = [151000, 192000, 114000, 171000, 160000];
array[CENTERS] of int: capacity = [1954, 1446, 820, 1640, 966];
array[STORES]  of int: demand   = [589, 962, 966, 643, 904];

array[CENTERS, STORES] of int: transCost =
  array2d(CENTERS, STORES,
    [ 5, 2, 3, 3, 3,
      5, 4, 3, 5, 2,
      4, 2, 4, 5, 1,
      4, 2, 5, 4, 1,
      1, 3, 3, 2, 4 ]);

int: totalDemand = sum(s in STORES)(demand[s]);

% Decision variables
array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var 0..totalDemand: ship;

% Demand satisfaction
constraint forall(s in STORES) (
  sum(c in CENTERS)(ship[c,s]) = demand[s]
);

% Capacity and opening linkage
constraint forall(c in CENTERS) (
  sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
);

% Helpful search to avoid timeouts on some backends
solve :: int_search([ship[c,s] | c in CENTERS, s in STORES], first_fail, indomain_min, complete)
  minimize
    sum(c in CENTERS)(openCost[c] * bool2int(open[c]))
  + sum(c in CENTERS, s in STORES)(transCost[c,s] * ship[c,s]);

output [
  "minimum_total_cost = ", show(
    sum(c in CENTERS)(openCost[c] * bool2int(open[c]))
    + sum(c in CENTERS, s in STORES)(transCost[c,s] * ship[c,s])
  ), "\n",
  "open = ", show([bool2int(open[c]) | c in CENTERS]), "\n",
  "ship =\n",
  concat([ concat([ show(ship[c,s]) ++ if s==nStores then "\n" else "\t" endif
                  | s in STORES ])
         | c in CENTERS ])
];