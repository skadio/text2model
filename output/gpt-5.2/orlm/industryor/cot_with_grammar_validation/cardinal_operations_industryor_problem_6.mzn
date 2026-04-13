int: W = 6;
int: P = 5;

set of int: Warehouses = 1..W;
set of int: Ports = 1..P;

array[Warehouses] of int: supply = [10, 12, 20, 24, 18, 40];
array[Ports] of int: demand = [20, 15, 25, 33, 21];

int: cost_per_km_per_container = 30;
int: truck_capacity = 2;

array[Warehouses, Ports] of int: dist_km = array2d(Warehouses, Ports, [
  290, 115, 355, 715, 810,
  380, 340, 165, 380, 610,
  505, 530, 285, 220, 450,
  655, 450, 155, 240, 315,
  1010, 840, 550, 305, 95,
  1072, 1097, 747, 372, 333
]);

array[Warehouses, Ports] of int: unit_cost =
  array2d(Warehouses, Ports,
    [ cost_per_km_per_container * dist_km[w,p] | w in Warehouses, p in Ports ]
  );

int: total_supply = sum(w in Warehouses)(supply[w]);
int: total_demand = sum(p in Ports)(demand[p]);

array[Warehouses, Ports] of var 0..total_supply: x;
array[Warehouses, Ports] of var 0..total_supply: trucks;

var 0..(max([unit_cost[w,p] | w in Warehouses, p in Ports]) * total_supply): total_cost;

constraint total_supply >= total_demand;

constraint forall(w in Warehouses)(
  sum(p in Ports)(x[w,p]) <= supply[w]
);

constraint forall(p in Ports)(
  sum(w in Warehouses)(x[w,p]) = demand[p]
);

constraint forall(w in Warehouses, p in Ports)(
  x[w,p] <= truck_capacity * trucks[w,p]
);

constraint forall(w in Warehouses, p in Ports)(
  trucks[w,p] <= x[w,p]
);

constraint total_cost = sum(w in Warehouses, p in Ports)(unit_cost[w,p] * trucks[w,p]);

solve minimize total_cost;