% Food supply redistribution among 6 regions (min-cost flow)

int: n_regions = 6;
set of int: R = 1..n_regions;

array[R] of int: food_available = [42, 32, 398, 224, 210, 209];
array[R] of int: food_required  = [74, 476, 2, 235, 221, 72];

array[R,R] of int: transport_cost =
  [|  0, 16, 48, 42, 50,  8
   | 27,  0, 23, 37, 39, 29
   | 49, 39,  0, 33, 50,  6
   | 23, 49, 46,  0, 50,  6
   | 45, 47, 48, 26,  0, 39
   | 33, 11,  9,  4, 12,  0 |];

% Derived data
array[R] of int: net_supply = [ food_available[r] - food_required[r] | r in R ];
set of int: S = { r | r in R where net_supply[r] > 0 };  % surplus regions
set of int: D = { r | r in R where net_supply[r] < 0 };  % deficit regions

% Feasibility: total supply must cover total demand
constraint sum(r in R)(food_available[r]) >= sum(r in R)(food_required[r]);

% Only ship from surplus to deficit; this greatly reduces the model size/search.
array[S, D] of var 0..max(i in S)(net_supply[i]): ship;

% Surplus cannot ship more than available surplus
constraint forall(i in S)(
  sum(j in D)(ship[i,j]) <= net_supply[i]
);

% Each deficit must receive at least its shortage
constraint forall(j in D)(
  sum(i in S)(ship[i,j]) >= -net_supply[j]
);

% Objective: minimize total transport cost
var int: total_cost = sum(i in S, j in D)(transport_cost[i,j] * ship[i,j]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "shipments (i->j: amount)\n"
] ++
[
  if fix(ship[i,j]) > 0 then
    show(i) ++ "->" ++ show(j) ++ ": " ++ show(ship[i,j]) ++ "\n"
  else
    ""
  endif
  | i in S, j in D
];