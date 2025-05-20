% Parameters
int: n_suppliers;
int: n_stores;
int: building_cost;
array[1..n_suppliers] of int: capacity;
array[1..n_stores, 1..n_suppliers] of int: cost_matrix;

% Variables
array[1..n_suppliers] of var 0..1: warehouse_open; % 1 if warehouse is open, 0 otherwise
array[1..n_stores, 1..n_suppliers] of var 0..1: store_supply; % 1 if store is supplied by warehouse, 0 otherwise

% Constraints
% Each store must be supplied by exactly one warehouse
constraint forall(i in 1..n_stores)(sum(j in 1..n_suppliers)(store_supply[i,j]) = 1);

% A warehouse can only supply a store if it is open
constraint forall(i in 1..n_stores, j in 1..n_suppliers)(store_supply[i,j] <= warehouse_open[j]);

% The total number of stores a warehouse can supply is limited by its capacity
constraint forall(j in 1..n_suppliers)(sum(i in 1..n_stores)(store_supply[i,j]) <= capacity[j]);

% Objective
% Minimize the sum of maintenance and supply costs
var int: total_cost = sum(j in 1..n_suppliers)(warehouse_open[j]*building_cost) + sum(i in 1..n_stores, j in 1..n_suppliers)(store_supply[i,j]*cost_matrix[i,j]);
solve minimize total_cost;