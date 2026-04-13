% Parameters (with values embedded)
int: numDC = 6;
int: numStores = 9;

set of int: DC = 1..numDC;
set of int: STORES = 1..numStores;

array[DC] of int: openingCost = [151000, 192000, 114000, 171000, 160000, 120000];

% Transportation cost per unit from each DC to each store
array[DC, STORES] of int: transCost =
[
  % Stores 1..9
  | 2, 3, 3, 4, 2, 1, 3, 4, 2   % DC1
  | 4, 2, 3, 1, 3, 2, 4, 3, 4   % DC2
  | 1, 1, 2, 2, 3, 3, 2, 1, 4   % DC3
  | 4, 1, 1, 2, 2, 3, 3, 2, 4   % DC4
  | 1, 4, 2, 3, 1, 2, 3, 4, 4   % DC5
  | 4, 4, 3, 2, 1, 2, 3, 4, 4   % DC6
];

% Demands (units) for stores 1..9 (explicitly embedded)
array[STORES] of int: demand = [401, 532, 678, 745, 812, 903, 955, 621, 488];

% Supply capacities (units) for DCs 1..6 (explicitly embedded)
array[DC] of int: capacity = [1795, 1450, 1620, 1500, 1310, 1095];

int: totalDemand = sum(s in STORES)(demand[s]);
int: maxUnitCost = max([transCost[d,s] | d in DC, s in STORES]);
int: maxTotalCost = sum(d in DC)(openingCost[d]) + maxUnitCost * totalDemand;

% Variables
array[DC] of var 0..1: open;
array[DC, STORES] of var 0..totalDemand: ship;

var 0..maxTotalCost: totalCost;

% Constraints
constraint forall(s in STORES) (
  sum(d in DC)(ship[d,s]) = demand[s]
);

constraint forall(d in DC) (
  sum(s in STORES)(ship[d,s]) <= capacity[d] * open[d]
);

% (Redundant but safe) Non-negativity already ensured by bounds
constraint forall(d in DC, s in STORES) ( ship[d,s] >= 0 );

% Objective
constraint totalCost =
  sum(d in DC)(openingCost[d] * open[d]) +
  sum(d in DC, s in STORES)(transCost[d,s] * ship[d,s]);

solve minimize totalCost;

output [
  "Optimal total cost = ", show(totalCost), "\n",
  "Open DCs: ", show([open[d] | d in DC]), "\n"
];