% Parameters
int: num_parts;
int: num_stores;

array[1..num_parts, 1..num_stores] of float: product_stores;
array[1..num_stores] of float: store_delivery_costs;

% Variables
array[1..num_parts] of var 1..num_stores: store_for_part;
array[1..num_stores] of var bool: used_store;

var float: total_product_cost;
var float: total_delivery_cost;
var float: total_cost;

% Constraints
constraint
  forall(s in 1..num_stores) (
    used_store[s] <-> exists(p in 1..num_parts) (store_for_part[p] = s)
  );

constraint
  total_product_cost = sum(p in 1..num_parts)( product_stores[p, store_for_part[p]] );

constraint
  total_delivery_cost = sum(s in 1..num_stores)( bool2int(used_store[s]) * store_delivery_costs[s] );

constraint
  total_cost = total_product_cost + total_delivery_cost;

% Objective
solve minimize total_cost;