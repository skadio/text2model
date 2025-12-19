% Parameters
int: num_parts; % Number of different parts to buy
int: num_stores; % Number of stores to choose from
array[1..num_parts, 1..num_stores] of int: product_stores; % Prices of each part in each store
array[1..num_stores] of int: store_delivery_costs; % Delivery cost of each store

% Variables
array[1..num_parts, 1..num_stores] of var 0..1: part_store_assignment; % Binary variable indicating whether a part is bought from a store
array[1..num_stores] of var 0..1: store_used; % Binary variable indicating whether a store is used

% Constraints

% Constraint 1: Each part must be bought from exactly one store
constraint forall(i in 1..num_parts) (
  sum(j in 1..num_stores) (part_store_assignment[i,j]) = 1
);

% Constraint 2: If a part is bought from a store, then the store is used
constraint forall(i in 1..num_parts, j in 1..num_stores) (
  part_store_assignment[i,j] <= store_used[j]
);

% Constraint 3: If a store is used, then at least one part is bought from it
constraint forall(j in 1..num_stores) (
  store_used[j] <= sum(i in 1..num_parts) (part_store_assignment[i,j])
);

% Objective
solve minimize sum(i in 1..num_parts, j in 1..num_stores) (part_store_assignment[i,j] * product_stores[i,j]) + sum(j in 1..num_stores) (store_used[j] * store_delivery_costs[j]);