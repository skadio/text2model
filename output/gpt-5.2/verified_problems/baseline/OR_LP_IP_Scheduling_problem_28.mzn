int: num_parts;
int: num_stores;

array[1..num_parts, 1..num_stores] of float: product_stores;
array[1..num_stores] of float: store_delivery_costs;

array[1..num_parts] of var 1..num_stores: store_for_part;
array[1..num_stores] of var bool: store_used;

constraint
  forall(s in 1..num_stores) (
    store_used[s] <-> exists(p in 1..num_parts)(store_for_part[p] = s)
  );

var float: total_cost =
  sum(p in 1..num_parts)( product_stores[p, store_for_part[p]] ) +
  sum(s in 1..num_stores)( (bool2int(store_used[s])) * store_delivery_costs[s] );

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "store_for_part=", show(store_for_part), "\n",
  "store_used=", show(store_used), "\n"
];