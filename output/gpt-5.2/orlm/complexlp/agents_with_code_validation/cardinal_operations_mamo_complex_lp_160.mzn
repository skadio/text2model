% Facility location / transportation with capacities
% Data embedded as requested

int: nCenters = 8;
int: nStores  = 5;

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost =
  [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

array[CENTERS, STORES] of int: transportCost =
  [| 3, 3, 5, 4, 3
   | 5, 2, 4, 2, 4
   | 5, 1, 4, 2, 5
   | 4, 1, 1, 3, 3
   | 2, 4, 4, 3, 4
   | 4, 1, 3, 5, 3
   | 5, 1, 2, 4, 1
   | 4, 2, 2, 1, 2 |];

array[STORES] of int: demand =
  [964, 739, 491, 766, 854];

array[CENTERS] of int: capacity =
  [1308, 1575, 834, 1005, 1904, 1825, 1821, 1365];

int: totalDemand = sum(s in STORES)(demand[s]);

% Decision variables
array[CENTERS] of var bool: open;

% Tighter bounds help performance and avoid timeouts on some solvers/backends
array[CENTERS, STORES] of var 0..max(demand): ship;

% Constraints

% Meet each store's demand exactly
constraint forall(s in STORES)(
  sum(c in CENTERS)(ship[c,s]) = demand[s]
);

% Center capacity and opening implication
constraint forall(c in CENTERS)(
  sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
);

% Objective
var int: total_cost =
    sum(c in CENTERS)(openCost[c] * bool2int(open[c]))
  + sum(c in CENTERS, s in STORES)(transportCost[c,s] * ship[c,s]);

solve :: int_search([ship[c,s] | c in CENTERS, s in STORES] ++ [bool2int(open[c]) | c in CENTERS],
                    first_fail, indomain_min, complete)
minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "open=", show([bool2int(open[c]) | c in CENTERS]), "\n",
  "ship=\n"
] ++
[
  "c" ++ show(c) ++ ": " ++ show([ship[c,s] | s in STORES]) ++ "\n"
  | c in CENTERS
];