% Parameters
int: num_parts;
int: num_stores;

set of int: PARTS = 1..num_parts;
set of int: STORES = 1..num_stores;

array[PARTS, STORES] of float: product_stores;
array[STORES] of float: store_delivery_costs;

% Variables
array[PARTS] of var STORES: store_of_part;
array[STORES] of var bool: used_store;

var float: total_product_cost;
var float: total_delivery_cost;
var float: total_cost;

% Constraints
constraint
  forall(s in STORES) (
    used_store[s] <-> exists(p in PARTS)(store_of_part[p] = s)
  );

constraint
  total_product_cost =
    sum(p in PARTS)( product_stores[p, store_of_part[p]] );

constraint
  total_delivery_cost =
    sum(s in STORES)( store_delivery_costs[s] * bool2int(used_store[s]) );

constraint
  total_cost = total_product_cost + total_delivery_cost;

% Objective
solve minimize total_cost;