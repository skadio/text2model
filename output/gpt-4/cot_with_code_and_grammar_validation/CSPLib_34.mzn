% Parameters
int: n_suppliers;
int: n_stores;
int: building_cost;
array[1..n_suppliers] of int: capacity;
array[1..n_stores, 1..n_suppliers] of int: cost_matrix;

% Variables
array[1..n_suppliers] of var 0..1: open; % whether each warehouse is open
array[1..n_stores, 1..n_suppliers] of var 0..1: supply; % whether each store is supplied by each warehouse

% Constraints
% Each store must be supplied by exactly one warehouse
constraint forall(i in 1..n_stores)(sum(j in 1..n_suppliers)(supply[i,j]) = 1);

% A warehouse can only supply a store if it is open
constraint forall(i in 1..n_stores, j in 1..n_suppliers)(supply[i,j] <= open[j]);

% The total number of stores supplied by a warehouse cannot exceed its capacity
constraint forall(j in 1..n_suppliers)(sum(i in 1..n_stores)(supply[i,j]) <= capacity[j]);

% Objective
% Minimize the sum of maintenance and supply costs
var int: total_cost = sum(j in 1..n_suppliers)(open[j]*building_cost) + sum(i in 1..n_stores, j in 1..n_suppliers)(supply[i,j]*cost_matrix[i,j]);
solve minimize total_cost;