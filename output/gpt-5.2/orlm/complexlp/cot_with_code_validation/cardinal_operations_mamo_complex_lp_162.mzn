% SupplyTek distribution network optimization (capacitated facility location)

% Parameters (embedded data)
int: nCenters = 7;
int: nStores  = 4;

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost =
  [151000, 192000, 114000, 171000, 160000, 120000, 182000];

array[CENTERS, STORES] of int: transCost =
 [| 3, 3, 5, 4
  | 3, 5, 2, 4
  | 2, 4, 5, 1
  | 4, 2, 5, 4
  | 1, 1, 3, 3
  | 2, 4, 4, 3
  | 4, 4, 1, 3 |];

array[STORES] of int: demand = [884, 420, 566, 673];
array[CENTERS] of int: capacity = [1187, 1400, 1115, 813, 1041, 1576, 1364];

int: totalDemand = sum(s in STORES)(demand[s]);

% Variables
array[CENTERS] of var bool: open;

% ship[c,s] cannot exceed demand[s] anyway; tighter bounds speed up solving.
array[CENTERS, STORES] of var 0..totalDemand: ship;

% Constraints
constraint
  forall(s in STORES)(
    sum(c in CENTERS)(ship[c,s]) = demand[s]
  );

constraint
  forall(c in CENTERS)(
    sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
  );

% Objective (direct expression; avoid extra var equality overhead)
solve
  minimize
    sum(c in CENTERS)(openCost[c] * bool2int(open[c])) +
    sum(c in CENTERS, s in STORES)(transCost[c,s] * ship[c,s]);

% Optional output
output [
  "Total cost = ", show(
    sum(c in CENTERS)(openCost[c] * bool2int(open[c])) +
    sum(c in CENTERS, s in STORES)(transCost[c,s] * ship[c,s])
  ), "\n",
  "Open centers: ", show([bool2int(open[c]) | c in CENTERS]), "\n",
  "Shipments (rows centers, cols stores):\n",
  concat([ concat([ show(ship[c,s]) ++ if s==nStores then "\n" else "\t" endif
                  | s in STORES ])
         | c in CENTERS ])
];