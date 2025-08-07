int: num_parts;
int: num_stores;

array[1..num_parts, 1..num_stores] of float: product_stores;
array[1..num_stores] of float: store_delivery_costs;

array[1..num_parts] of var 1..num_stores: assignment;
array[1..num_stores] of var bool: used;

constraint
  forall(s in 1..num_stores) (
    used[s] = exists(p in 1..num_parts)(assignment[p] == s)
  );

var float: total_cost =
  sum(p in 1..num_parts) product_stores[p, assignment[p]] +
  sum(s in 1..num_stores) (if used[s] then store_delivery_costs[s] else 0.0 endif);

solve minimize total_cost;

output [
  "Total cost: " ++ show(total_cost) ++ "\n",
  "Assignment: " ++ show(assignment) ++ "\n"
];