int: W = 6;
int: P = 5;

set of int: WAREHOUSES = 1..W;
set of int: PORTS = 1..P;

array[WAREHOUSES] of int: supply = [10, 12, 20, 24, 18, 40];
array[PORTS] of int: demand = [20, 15, 25, 33, 21];

int: rate_eur_per_km = 30;
int: truck_capacity = 2;

array[WAREHOUSES, PORTS] of int: dist_km =
  [|  290,  115,  355,  715,  810
   |  380,  340,  165,  380,  610
   |  505,  530,  285,  220,  450
   |  655,  450,  155,  240,  315
   | 1010,  840,  550,  305,   95
   | 1072, 1097,  747,  372,  333
  |];

array[WAREHOUSES, PORTS] of int: cost_per_container =
  array2d(WAREHOUSES, PORTS,
    [ rate_eur_per_km * dist_km[w,p] | w in WAREHOUSES, p in PORTS ]
  );

int: total_supply = sum(w in WAREHOUSES)(supply[w]);
int: total_demand = sum(p in PORTS)(demand[p]);

constraint total_supply >= total_demand;

int: max_supply = max(w in WAREHOUSES)(supply[w]);

array[WAREHOUSES, PORTS] of var 0..max_supply: x;
array[WAREHOUSES, PORTS] of var 0..max_supply: trucks;

constraint forall(w in WAREHOUSES)(
  sum(p in PORTS)(x[w,p]) <= supply[w]
);

constraint forall(p in PORTS)(
  sum(w in WAREHOUSES)(x[w,p]) = demand[p]
);

constraint forall(w in WAREHOUSES, p in PORTS)(
  x[w,p] <= truck_capacity * trucks[w,p]
);

solve minimize sum(w in WAREHOUSES, p in PORTS)(
  cost_per_container[w,p] * x[w,p]
);

output [
  "Total cost (EUR): ",
  show(sum(w in WAREHOUSES, p in PORTS)(cost_per_container[w,p] * x[w,p])),
  "\n",
  "Shipments x[w,p] (containers):\n",
  concat([
    concat([
      show(x[w,p]) ++ (if p == P then "\n" else "\t" endif)
      | p in PORTS
    ])
    | w in WAREHOUSES
  ])
];