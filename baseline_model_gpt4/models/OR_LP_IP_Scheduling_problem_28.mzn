include "globals.mzn";

% Number of different parts to buy
int: num_parts;

% Number of stores to choose from
int: num_stores;

% Prices of each part in each store
array[1..num_parts, 1..num_stores] of float: product_stores;

% Delivery cost of each store
array[1..num_stores] of float: store_delivery_costs;

% Decision variable: store[i,j] is 1 if part i is bought from store j, 0 otherwise
array[1..num_parts, 1..num_stores] of var 0..1: store;

% Objective: Minimize the total cost
var float: total_cost = sum(i in 1..num_parts, j in 1..num_stores) (store[i,j] * product_stores[i,j]) + sum(j in 1..num_stores) (max(1, sum(i in 1..num_parts) (store[i,j])) * store_delivery_costs[j]);

% Constraint: Each part must be bought from exactly one store
constraint forall(i in 1..num_parts) (sum(j in 1..num_stores) (store[i,j]) = 1);

% Solve the problem
solve minimize total_cost;

% Output the solution
output [ if fix(store[i,j]) = 1 then "Part " ++ show(i) ++ " is bought from store " ++ show(j) ++ "\n" else "" endif | i in 1..num_parts, j in 1..num_stores ];