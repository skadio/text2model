% Parameters
int: num_parts;
int: num_stores;
array[1..num_parts, 1..num_stores] of float: product_stores;
array[1..num_stores] of float: store_delivery_costs;

% Variables
array[1..num_parts, 1..num_stores] of var 0..1: x;          % x[p,s] = 1 if part p is bought from store s
array[1..num_stores]                 of var 0..1: store_used; % 1 if any part is bought from store s

% Constraints

% Each part must be purchased from exactly one store
constraint
  forall(p in 1..num_parts)(
    sum(s in 1..num_stores)( x[p,s] ) = 1
  );

% Link store_used with the assignment variables
constraint
  forall(s in 1..num_stores, p in 1..num_parts)(
    x[p,s] <= store_used[s]
  );

constraint
  forall(s in 1..num_stores)(
    store_used[s] <= sum(p in 1..num_parts)( x[p,s] )
  );

% Objective
solve minimize
  sum(p in 1..num_parts, s in 1..num_stores)( product_stores[p,s] * x[p,s] ) +
  sum(s in 1..num_stores)( store_delivery_costs[s] * store_used[s] );