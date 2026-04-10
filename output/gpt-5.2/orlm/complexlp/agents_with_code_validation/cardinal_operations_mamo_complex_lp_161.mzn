% Facility location / distribution with capacities (MIP)
% Data embedded as requested.

int: nCenters = 5;
int: nStores  = 7;

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost = [151000, 192000, 114000, 171000, 160000];
array[CENTERS] of int: capacity = [1576, 1364, 1697,  891, 1755];
array[STORES]  of int: demand   = [ 566,  673,  787, 1000,  715,  413,  641];

array[CENTERS, STORES] of int: shipCost =
 [| 5, 2, 3, 3, 3, 5, 4
  | 3, 5, 2, 4, 2, 4, 5
  | 1, 4, 2, 5, 4, 1, 1
  | 3, 3, 2, 4, 4, 3, 4
  | 4, 1, 3, 5, 3, 5, 1 |];

int: totalDemand = sum(s in STORES)(demand[s]);

% Decision variables
array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var 0..totalDemand: flow;

% Constraints: meet each store demand exactly
constraint forall(s in STORES) (
  sum(c in CENTERS)(flow[c,s]) = demand[s]
);

% Capacity only if opened
constraint forall(c in CENTERS) (
  sum(s in STORES)(flow[c,s]) <= capacity[c] * bool2int(open[c])
);

% Objective (define directly to avoid huge-domain auxiliary var)
var int: totalCost =
  sum(c in CENTERS)(openCost[c] * bool2int(open[c])) +
  sum(c in CENTERS, s in STORES)(shipCost[c,s] * flow[c,s]);

solve minimize totalCost;

output [
  "totalCost = ", show(totalCost), "\n",
  "open = ", show([bool2int(open[c]) | c in CENTERS]), "\n",
  "flow =\n"
] ++
[
  "  center " ++ show(c) ++ ": " ++ show([flow[c,s] | s in STORES]) ++ "\n"
  | c in CENTERS
];