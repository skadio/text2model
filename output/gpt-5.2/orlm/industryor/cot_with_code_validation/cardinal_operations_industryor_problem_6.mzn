% Transportation of empty containers: minimize total cost

% Sets
int: W = 6;
int: P = 5;
set of int: Warehouses = 1..W;
set of int: Ports = 1..P;

% Data (embedded)
array[Warehouses] of int: supply = [10, 12, 20, 24, 18, 40];
array[Ports] of int: demand = [20, 15, 25, 33, 21];

array[Warehouses, Ports] of int: dist_km =
[|  290,  115,  355,  715,  810
 |  380,  340,  165,  380,  610
 |  505,  530,  285,  220,  450
 |  655,  450,  155,  240,  315
 | 1010,  840,  550,  305,   95
 | 1072, 1097,  747,  372,  333 |];

int: rate_eur_per_km = 30;
int: truck_capacity = 2;

% Precompute costs
array[Warehouses, Ports] of int: cost_per_container =
  array2d(Warehouses, Ports,
    [ rate_eur_per_km * dist_km[w,p] | w in Warehouses, p in Ports ]
  );

% Feasibility check (total supply must cover total demand)
constraint sum(w in Warehouses)(supply[w]) >= sum(p in Ports)(demand[p]);

% Decision variables: shipped containers
int: total_demand = sum(p in Ports)(demand[p]);
array[Warehouses, Ports] of var 0..total_demand: x;

% Supply and demand constraints
constraint forall(w in Warehouses)(
  sum(p in Ports)(x[w,p]) <= supply[w]
);

constraint forall(p in Ports)(
  sum(w in Warehouses)(x[w,p]) = demand[p]
);

% Objective: total cost of shipped containers
var int: total_cost = sum(w in Warehouses, p in Ports)(x[w,p] * cost_per_container[w,p]);

solve minimize total_cost;

output [
  "Total cost (EUR): ", show(total_cost), "\n",
  "Shipments x[w,p] (containers):\n"
] ++
[
  "Warehouse ", show(w), ": " ++
  concat([ if p > 1 then " " else "" endif ++ show(x[w,p]) | p in Ports ]) ++ "\n"
  | w in Warehouses
];