% Facility Location + Capacitated Transportation (single-sourcing)
% Data embedded as requested.

include "globals.mzn";

int: m = 6;  % distribution centers
int: n = 8;  % stores

set of int: C = 1..m;
set of int: S = 1..n;

array[C] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];

array[S] of int: demand = [908, 434, 605, 480, 961, 787, 401, 789];

array[C] of int: cap = [1365, 1929, 1502, 1201, 1529, 961];

% Transportation cost per unit from center c to store s
array[C, S] of int: shipCost =
  [| 2, 3, 1, 2, 3, 4, 5, 5   % center 1
   | 2, 4, 2, 2, 1, 3, 4, 2   % center 2
   | 5, 4, 3, 4, 2, 1, 2, 4   % center 3
   | 4, 3, 2, 1, 2, 3, 4, 3   % center 4
   | 5, 1, 2, 3, 4, 5, 3, 2   % center 5
   | 1, 2, 3, 4, 5, 1, 2, 4   % center 6
  |];

% Decision: assign each store to exactly one center (single-sourcing)
array[S] of var C: assign;

% Whether a center is opened
array[C] of var 0..1: open;

% Linking: a center is open if it serves at least one store
constraint forall(c in C)(
  open[c] = bool2int(exists(s in S)(assign[s] = c))
);

% Capacity constraints: total demand assigned to each center cannot exceed its capacity
constraint forall(c in C)(
  sum(s in S)(demand[s] * bool2int(assign[s] = c)) <= cap[c]
);

% Objective: opening + shipping costs
var int: totalOpenCost = sum(c in C)(openCost[c] * open[c]);
var int: totalShipCost = sum(s in S)(demand[s] * shipCost[assign[s], s]);
var int: totalCost = totalOpenCost + totalShipCost;

solve minimize totalCost;

output [
  "Total cost = ", show(totalCost), "\n",
  "  Opening cost = ", show(totalOpenCost), "\n",
  "  Shipping cost = ", show(totalShipCost), "\n\n",
  "Open centers (1=open): ", show(open), "\n",
  "Store assignments (store -> center): ", show(assign), "\n"
];