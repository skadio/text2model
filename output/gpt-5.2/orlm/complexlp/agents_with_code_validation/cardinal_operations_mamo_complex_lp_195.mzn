% China Railroad freight car relocation - Min-cost flow (LP/MIP)

int: nRegions = 5;
set of int: R = 1..nRegions;

array[R,R] of int: cost =
  [|  0, 10, 12, 17, 34
   | 10,  0, 18,  8, 46
   | 12, 18,  0,  9, 27
   | 17,  8,  9,  0, 20
   | 34, 46, 27, 20,  0 |];

array[R] of int: available = [115, 385, 410, 480, 610];
array[R] of int: required  = [300, 400, 800, 200, 300];

% Demand (positive means needs cars), Supply (positive means extra cars)
array[R] of int: demand = [ required[r] - available[r] | r in R ];
array[R] of int: supply = [ max(0, -demand[r]) | r in R ];
array[R] of int: need   = [ max(0,  demand[r]) | r in R ];

int: total_supply = sum(r in R)(supply[r]);
int: total_need   = sum(r in R)(need[r]);

% Feasibility check
constraint total_supply >= total_need;

% Only model shipments from surplus regions to deficit regions (much smaller => faster)
set of int: S = { r | r in R where supply[r] > 0 };
set of int: D = { r | r in R where need[r] > 0 };

array[S,D] of var 0..total_supply: ship;

% Supply limits
constraint forall(i in S)(
  sum(j in D)(ship[i,j]) <= supply[i]
);

% Demand satisfaction (must meet needs)
constraint forall(j in D)(
  sum(i in S)(ship[i,j]) >= need[j]
);

solve minimize sum(i in S, j in D)(cost[i,j] * ship[i,j]);