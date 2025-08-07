include "globals.mzn";

int: n_suppliers;                     % Number of warehouse candidates
int: n_stores;                         % Number of stores
int: building_cost;                    % Cost of opening a warehouse
array[1..n_suppliers] of int: capacity; % Capacity of each warehouse
array[1..n_stores, 1..n_suppliers] of int: cost_matrix; % Supply cost matrix

/* Decision variables */
array[1..n_suppliers] of var 0..1: open; % 1 if warehouse is opened, 0 otherwise
array[1..n_stores] of var 1..n_suppliers: supply; % Warehouse supplying each store

/* Objective: Minimize total cost */
var int: total_cost = sum(i in 1..n_suppliers)(open[i] * building_cost) + 
                      sum(j in 1..n_stores)(cost_matrix[j, supply[j]]);

/* Constraints */
% Each store must be supplied by exactly one warehouse
constraint forall(j in 1..n_stores)(supply[j] in 1..n_suppliers);

% Capacity constraints
constraint forall(i in 1..n_suppliers)(
    sum(j in 1..n_stores)(if supply[j] = i then 1 else 0 endif) <= open[i] * capacity[i]
);

/* Solve & output */
solve minimize total_cost;
output [ "Total Cost = ", show(total_cost), "\n", 
         "Warehouses Opened = ", show(open), "\n", 
         "Supply Assignments = ", show(supply), "\n" ];