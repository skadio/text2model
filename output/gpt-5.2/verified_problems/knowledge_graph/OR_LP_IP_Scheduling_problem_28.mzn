int: num_parts;
int: num_stores;

set of int: PARTS = 1..num_parts;
set of int: STORES = 1..num_stores;

array[PARTS, STORES] of float: product_stores;
array[STORES] of float: store_delivery_costs;

array[PARTS] of var STORES: store_of_part;
array[STORES] of var bool: used_store;

constraint
  forall(s in STORES) (
    used_store[s] <-> exists(p in PARTS)(store_of_part[p] = s)
  );

var float: total_cost =
  sum(p in PARTS)(product_stores[p, store_of_part[p]]) +
  sum(s in STORES)(store_delivery_costs[s] * bool2int(used_store[s]));

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "store_of_part=", show(store_of_part), "\n",
  "used_store=", show(used_store), "\n"
];