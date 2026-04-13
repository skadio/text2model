% Parameters
int: num_parts;
int: num_stores;

array[1..num_parts, 1..num_stores] of float: product_stores;
array[1..num_stores] of float: store_delivery_costs;

% Variables
array[1..num_parts] of var 1..num_stores: part_store;
array[1..num_stores] of var bool: store_used;

% Constraints: store_used iff at least one part is bought from that store
constraint
  forall(s in 1..num_stores) (
    store_used[s] <-> exists(p in 1..num_parts) (part_store[p] = s)
  );

% Objective (direct expression; avoid var float equalities for compatibility)
var float: total_cost =
  sum(p in 1..num_parts) (product_stores[p, part_store[p]]) +
  sum(s in 1..num_stores) (store_delivery_costs[s] * bool2int(store_used[s]));

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "part_store=", show(part_store), "\n",
  "store_used=", show(store_used), "\n"
];