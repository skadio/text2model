% Freight car relocation (min-cost flow) among 5 regions
% Data embedded as required.

int: R = 5;
set of int: REGIONS = 1..R;

array[REGIONS, REGIONS] of int: cost =
  [|  0, 10, 12, 17, 34
   | 10,  0, 18,  8, 46
   | 12, 18,  0,  9, 27
   | 17,  8,  9,  0, 20
   | 34, 46, 27, 20,  0 |];

array[REGIONS] of int: available = [115, 385, 410, 480, 610];
array[REGIONS] of int: needed    = [300, 400, 800, 200, 300];

% Positive => demand (deficit), negative => supply (surplus)
array[REGIONS] of int: deficit = [needed[i] - available[i] | i in REGIONS];

int: total_deficit = sum(i in REGIONS where deficit[i] > 0)(deficit[i]);
int: total_surplus = sum(i in REGIONS where deficit[i] < 0)(-deficit[i]);

% Feasibility check (must balance)
constraint total_deficit = total_surplus;

% Decision variables:
% x[i,j] = cars moved from i to j (only allow moves from surplus to deficit)
array[REGIONS, REGIONS] of var 0..total_surplus: x;

% Disallow self-moves
constraint forall(i in REGIONS)(x[i,i] = 0);

% Enforce that only surplus regions send and only deficit regions receive
constraint forall(i in REGIONS, j in REGIONS where i != j)(
  (deficit[i] < 0 /\ deficit[j] > 0) \/ x[i,j] = 0
);

% Supply constraints for surplus regions: total outflow equals surplus amount
constraint forall(i in REGIONS where deficit[i] < 0)(
  sum(j in REGIONS)(x[i,j]) = -deficit[i]
);

% Demand constraints for deficit regions: total inflow equals deficit amount
constraint forall(j in REGIONS where deficit[j] > 0)(
  sum(i in REGIONS)(x[i,j]) = deficit[j]
);

var int: total_cost = sum(i in REGIONS, j in REGIONS)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "Total cost = ", show(total_cost), "\n",
  "Moves (i->j: cars):\n"
] ++
[
  if i != j /\ (deficit[i] < 0 /\ deficit[j] > 0) then
    show(i) ++ "->" ++ show(j) ++ ": " ++ show(x[i,j]) ++ "\n"
  else
    ""
  endif
  | i in REGIONS, j in REGIONS
];