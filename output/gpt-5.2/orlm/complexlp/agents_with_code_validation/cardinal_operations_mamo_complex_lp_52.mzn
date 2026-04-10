% Medical supplies redistribution (min-cost flow)

int: nRegions = 5;
set of int: REGIONS = 1..nRegions;

array[REGIONS] of int: initial_stock = [410, 266, 132, 6, 485];
array[REGIONS] of int: required      = [274, 331, 232, 359, 74];

array[REGIONS, REGIONS] of int: cost =
  [| 0, 24,  3, 27, 31
   |24,  0, 11,  7, 37
   |30,  1,  0, 38, 22
   |36, 18, 17,  0, 35
   |41, 35, 33, 33,  0 |];

array[REGIONS] of int: surplus = [ initial_stock[r] - required[r] | r in REGIONS ];

% Feasibility check (must be nonnegative total surplus)
constraint sum(r in REGIONS)(surplus[r]) >= 0;

set of int: SUP = { r | r in REGIONS where surplus[r] > 0 };
set of int: DEM = { r | r in REGIONS where surplus[r] < 0 };

% Ship only from surplus regions to deficit regions
array[SUP, DEM] of var 0..max(initial_stock): ship;

% Surplus regions: cannot ship more than surplus
constraint forall(i in SUP)(
  sum(j in DEM)(ship[i,j]) <= surplus[i]
);

% Deficit regions: must receive at least deficit amount
constraint forall(j in DEM)(
  sum(i in SUP)(ship[i,j]) >= -surplus[j]
);

% Minimize total transportation cost
var int: total_cost =
  sum(i in SUP, j in DEM)( cost[i,j] * ship[i,j] );

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n"
];