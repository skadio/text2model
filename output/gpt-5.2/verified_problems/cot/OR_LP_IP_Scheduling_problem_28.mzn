% Parameters
int: num_parts;
int: num_stores;

array[1..num_parts, 1..num_stores] of float: product_stores;
array[1..num_stores] of float: store_delivery_costs;

% Variables
array[1..num_parts] of var 1..num_stores: store_of_part;
array[1..num_parts, 1..num_stores] of var 0..1: x;           % x[p,s]=1 if part p bought at store s
array[1..num_stores] of var 0..1: used_store;                % 1 if any part is bought at store s

var float: total_cost;

% Constraints
constraint
  forall(p in 1..num_parts) (
    sum(s in 1..num_stores)(x[p,s]) = 1
  );

constraint
  forall(p in 1..num_parts, s in 1..num_stores) (
    x[p,s] = bool2int(store_of_part[p] = s)
  );

constraint
  forall(s in 1..num_stores) (
    used_store[s] >= max(p in 1..num_parts)(x[p,s])
  );

constraint
  total_cost =
    sum(p in 1..num_parts, s in 1..num_stores)(product_stores[p,s] * int2float(x[p,s])) +
    sum(s in 1..num_stores)(store_delivery_costs[s] * int2float(used_store[s]));

% Objective
solve minimize total_cost;