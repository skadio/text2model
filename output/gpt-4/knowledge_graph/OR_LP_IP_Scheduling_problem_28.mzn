include "globals.mzn";

% Parameters
int: num_parts; % Number of different parts to buy
int: num_stores; % Number of stores to choose from
array[1..num_parts, 1..num_stores] of int: product_stores; % Prices of each part in each store
array[1..num_stores] of int: store_delivery_costs; % Delivery cost of each store

% Variables
array[1..num_parts] of var 1..num_stores: store_assignment; % Store assignment for each part
array[1..num_stores] of var 0..1: store_used; % Whether each store is used or not

% Constraints
constraint forall(i in 1..num_parts)(store_used[store_assignment[i]] = 1);

% Objective
var int: total_cost = sum(i in 1..num_parts)(product_stores[i, store_assignment[i]]) + sum(i in 1..num_stores)(store_used[i] * store_delivery_costs[i]);
solve minimize total_cost;

% Output
output ["Total cost: ", show(total_cost), "\nStore assignments: "] ++ [show(store_assignment[i]) | i in 1..num_parts];