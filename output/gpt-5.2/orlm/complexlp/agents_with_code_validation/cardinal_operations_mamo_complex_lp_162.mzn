% SupplyTek distribution center location + shipment optimization
% Data embedded (no .dzn required)

int: nCenters = 7;
int: nStores  = 4;

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000];

array[CENTERS, STORES] of int: transCost =
  array2d(CENTERS, STORES, [
    3, 3, 5, 4,
    3, 5, 2, 4,
    2, 4, 5, 1,
    4, 2, 5, 4,
    1, 1, 3, 3,
    2, 4, 4, 3,
    4, 4, 1, 3
  ]);

array[STORES] of int: demand = [884, 420, 566, 673];
array[CENTERS] of int: capacity = [1187, 1400, 1115, 813, 1041, 1576, 1364];

int: totalDemand = sum(s in STORES)(demand[s]);

% Use MIP for speed/robustness (avoids search-based timeout)
solve :: int_search([] , input_order, indomain_min, complete)
     :: mip()
     minimize
       sum(c in CENTERS)(openCost[c] * bool2int(open[c]))
     + sum(c in CENTERS, s in STORES)(transCost[c,s] * ship[c,s]);

% Decision variables
array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var 0..totalDemand: ship;

% Demand must be met exactly
constraint forall(s in STORES)(
  sum(c in CENTERS)(ship[c,s]) = demand[s]
);

% Capacity and linking (no shipping unless open; total outflow within capacity)
constraint forall(c in CENTERS)(
  sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
);

output [
  "Minimum total cost = ", show(
    sum(c in CENTERS)(openCost[c] * bool2int(open[c]))
    + sum(c in CENTERS, s in STORES)(transCost[c,s] * ship[c,s])
  ), "\n",
  "Open centers: ", show([bool2int(open[c]) | c in CENTERS]), "\n",
  "Shipments (rows=center, cols=store):\n",
  concat([ concat([ show(ship[c,s]) ++ if s < nStores then "\t" else "\n" endif
                   | s in STORES ])
          | c in CENTERS ])
];