% Facility location / distribution planning for DistribuMax
% Data embedded as requested.

int: nCenters = 9;
int: nStores  = 9;

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost =
  [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000];

array[STORES] of int: demand =
  [871, 462, 538, 898, 992, 791, 818, 688, 778];

array[CENTERS] of int: capacity =
  [1265, 1091, 1663, 1699, 1350, 1293, 1180, 1856, 840];

array[CENTERS, STORES] of int: shipCost =
  [| 2, 4, 5, 2, 1, 3, 4, 3, 2
   | 3, 2, 3, 4, 2, 1, 5, 2, 3
   | 4, 3, 2, 5, 3, 2, 1, 4, 2
   | 2, 5, 4, 1, 2, 3, 2, 5, 4
   | 1, 2, 3, 2, 4, 5, 3, 1, 2
   | 3, 1, 2, 3, 5, 4, 2, 2, 1
   | 5, 3, 1, 4, 3, 2, 4, 2, 5
   | 2, 4, 3, 5, 1, 2, 3, 4, 2
   | 4, 2, 5, 3, 2, 1, 2, 3, 4 |];

% Precompute bounds to help the solver
int: maxDem = max(demand);
int: sumDem = sum(s in STORES)(demand[s]);

% Variables
array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var 0..maxDem: ship;
var 0..(sum(openCost) + 5 * sumDem): totalCost;

% Constraints

% Demand satisfaction (exactly meet each store demand)
constraint
  forall(s in STORES) (
    sum(c in CENTERS)(ship[c,s]) = demand[s]
  );

% Capacity and activation linking
constraint
  forall(c in CENTERS) (
    sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
  );

% Optional strengthening: if a center is open, it must ship at least 1 unit
% (helps reduce symmetric open-but-unused solutions)
constraint
  forall(c in CENTERS)(
    sum(s in STORES)(ship[c,s]) >= bool2int(open[c])
  );

% Total cost
constraint
  totalCost =
    sum(c in CENTERS)(openCost[c] * bool2int(open[c])) +
    sum(c in CENTERS, s in STORES)(shipCost[c,s] * ship[c,s]);

% Solve (use a MIP solver if available; helps avoid timeouts)
solve :: int_search([ship[c,s] | c in CENTERS, s in STORES] ++ [bool2int(open[c]) | c in CENTERS],
                    first_fail, indomain_min, complete)
minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show([open[c] | c in CENTERS]), "\n"
];