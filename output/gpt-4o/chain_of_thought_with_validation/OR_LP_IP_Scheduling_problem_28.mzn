% Parameters
int: num_parts;
int: num_stores;

array[1..num_parts, 1..num_stores] of float: product_stores;
array[1..num_stores] of float: store_delivery_costs;

% Variables
array[1..num_parts] of var 1..num_stores: store_of_part;          % store chosen for each part
array[1..num_stores] of var 0..1: store_used;                     % 1 if at least one part bought in store

var float: total_cost =
    sum(p in 1..num_parts)( product_stores[p, store_of_part[p]] ) +
    sum(s in 1..num_stores)( store_delivery_costs[s] * store_used[s] );

% Constraints
constraint
  forall(s in 1..num_stores)(
    store_used[s] = bool2int( exists(p in 1..num_parts)( store_of_part[p] = s ) )
  );

% Objective
solve minimize total_cost;