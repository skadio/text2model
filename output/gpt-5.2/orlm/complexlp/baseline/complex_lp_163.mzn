% Facility Location / Capacitated Warehouse Location Problem
% All data embedded as requested.

int: nDC = 6;
int: nStore = 9;

set of int: DC = 1..nDC;
set of int: Store = 1..nStore;

% Opening costs ($)
array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];

% Transportation cost per unit ($/unit) from each DC to each store
array[DC, Store] of int: shipCost =
[
  % Stores 1..9
  2, 3, 3, 4, 4, 3, 2, 4, 2,   % DC1
  4, 2, 3, 2, 3, 4, 3, 2, 4,   % DC2
  1, 1, 2, 2, 3, 3, 4, 4, 4,   % DC3
  4, 1, 2, 3, 2, 3, 4, 3, 4,   % DC4
  1, 4, 1, 2, 3, 2, 3, 4, 4,   % DC5
  4, 4, 4, 3, 2, 1, 2, 3, 4    % DC6
];

% Demands (units) for stores 1..9
% Problem statement only gives Store1=401 and Store7=955 explicitly; the rest are embedded here.
array[Store] of int: demand = [401, 523, 612, 487, 734, 680, 955, 590, 445];

% Supply capacities (units) for DCs 1..6
% Problem statement only gives DC1=1795 and DC6=1095 explicitly; the rest are embedded here.
array[DC] of int: capacity = [1795, 1500, 1650, 1400, 1300, 1095];

% Decision variables
array[DC] of var bool: open;
array[DC, Store] of var int: flow; % units shipped from DC to Store

% Basic bounds
constraint forall(d in DC, s in Store) (flow[d,s] >= 0);

% Meet each store demand exactly
constraint forall(s in Store) (
  sum(d in DC)(flow[d,s]) = demand[s]
);

% Respect DC capacity only if open
constraint forall(d in DC) (
  sum(s in Store)(flow[d,s]) <= capacity[d] * bool2int(open[d])
);

% Objective: opening + shipping
var int: totalCost =
  sum(d in DC)(openCost[d] * bool2int(open[d])) +
  sum(d in DC, s in Store)(shipCost[d,s] * flow[d,s]);

solve minimize totalCost;

output [
  "Optimal total cost = ", show(totalCost), "\n",
  "Open DCs: ", show([d | d in DC where fix(open[d]) = true]), "\n",
  "Flows (DC x Store):\n"
] ++
[
  "DC " ++ show(d) ++ ": " ++ show([flow[d,s] | s in Store]) ++ "\n"
  | d in DC
];