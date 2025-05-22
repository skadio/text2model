% Parameters
int: num_parts;
int: num_stores;
array[1..num_parts, 1..num_stores] of float: product_stores;
array[1..num_stores] of float: store_delivery_costs;

% Variables
array[1..num_parts, 1..num_stores] of var 0..1: buy;

% Constraints
constraint forall(i in 1..num_parts)(sum(j in 1..num_stores)(buy[i,j]) = 1);

% Objective
var float: total_cost = sum(i in 1..num_parts, j in 1..num_stores)(buy[i,j]*product_stores[i,j]) + sum(j in 1..num_stores)(max([buy[i,j] | i in 1..num_parts])*store_delivery_costs[j]);
solve minimize total_cost;