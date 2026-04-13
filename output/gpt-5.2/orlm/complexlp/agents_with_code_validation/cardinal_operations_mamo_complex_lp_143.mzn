% Facility Location / Distribution Network Design
% Data embedded (no .dzn required)

include "globals.mzn";

int: nCenters = 6;
int: nStores  = 8;

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost =
  [151000, 192000, 114000, 171000, 160000, 120000];

array[CENTERS, STORES] of int: transportCost =
  array2d(CENTERS, STORES,
    [ 2,3,3,3,5,4,3,5,    % center 1
      2,4,2,4,5,1,4,2,    % center 2
      5,4,1,1,3,3,2,4,    % center 3
      4,3,4,4,1,3,5,3,    % center 4
      5,1,2,4,1,4,2,2,    % center 5
      1,2,5,2,4,4,4,4     % center 6
    ]);

array[STORES] of int: demand =
  [908, 434, 605, 480, 961, 787, 401, 789];

array[CENTERS] of int: capacity =
  [1365, 1929, 1502, 1201, 1529, 961];

% Precompute for tighter domains
int: totalDemand = sum(s in STORES)(demand[s]);
int: maxUnitCost = max([ transportCost[c,s] | c in CENTERS, s in STORES ]);
int: maxOpenCost = sum(c in CENTERS)(openCost[c]);
int: maxShipCost = maxUnitCost * totalDemand;
int: maxTotalCost = maxOpenCost + maxShipCost;

% Decision variables
array[CENTERS] of var bool: open;

% Shipments: bound each arc by min(demand, capacity) and by opening decision
array[CENTERS, STORES] of var 0..max([min(demand[s], capacity[c]) | c in CENTERS, s in STORES]): ship;

% Constraints

% Demand satisfaction
constraint
  forall(s in STORES)(
    sum(c in CENTERS)(ship[c,s]) = demand[s]
  );

% Capacity + opening linkage (also implies ship=0 if not open)
constraint
  forall(c in CENTERS)(
    sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
  );

% Strengthening: per-arc linkage to avoid big search (ship only if open)
constraint
  forall(c in CENTERS, s in STORES)(
    ship[c,s] <= demand[s] * bool2int(open[c])
  );

% Symmetry-breaking / guidance: open cheapest facility (often helps)
constraint open[6] = true;

% Objective
var 0..maxOpenCost: totalOpenCost =
  sum(c in CENTERS)(openCost[c] * bool2int(open[c]));

var 0..maxShipCost: totalTransportCost =
  sum(c in CENTERS, s in STORES)(transportCost[c,s] * ship[c,s]);

var 0..maxTotalCost: totalCost = totalOpenCost + totalTransportCost;

solve :: int_search([ship[c,s] | c in CENTERS, s in STORES] ++ [bool2int(open[c]) | c in CENTERS],
                    first_fail, indomain_min, complete)
minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show(open), "\n",
  "totalOpenCost=", show(totalOpenCost), "\n",
  "totalTransportCost=", show(totalTransportCost), "\n"
];