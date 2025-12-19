int: num_parts;                          % Number of different parts to buy
int: num_stores;                         % Number of stores to choose from
array[1..num_parts, 1..num_stores] of float: product_stores; % Prices of each part in each store
array[1..num_stores] of float: store_delivery_costs; % Delivery cost of each store

/* Variables */
array[1..num_parts] of var 1..num_stores: store_assignment; % Store assigned to each part

/* Objective: Minimize total cost */
var float: total_cost = sum(i in 1..num_parts)(product_stores[i, store_assignment[i]]) 
                        + sum(j in 1..num_stores)(store_delivery_costs[j] * (if sum(i in 1..num_parts)(if store_assignment[i] == j then 1 else 0 endif) > 0 then 1 else 0 endif));

/* Solve */
solve minimize total_cost;

/* Output */
output [ "Total Cost = ", show(total_cost), "\nStore Assignments = ", show(store_assignment), "\n" ];