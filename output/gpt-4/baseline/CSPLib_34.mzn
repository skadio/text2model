% Define the parameters
int: n_suppliers; % Number of warehouse candidates
int: n_stores; % Number of stores
int: building_cost; % Cost of opening a warehouse
array[1..n_suppliers] of int: capacity; % Capacity of each warehouse
array[1..n_stores, 1..n_suppliers] of int: cost_matrix; % Cost of a store being supplied by a warehouse

% Define the decision variables
array[1..n_suppliers] of var 0..1: warehouse_open; % Whether each warehouse is open
array[1..n_stores, 1..n_suppliers] of var 0..1: store_supply; % Whether each store is supplied by each warehouse

% Define the objective function
var int: total_cost = sum(i in 1..n_suppliers) (warehouse_open[i] * building_cost) + sum(i in 1..n_stores, j in 1..n_suppliers) (store_supply[i,j] * cost_matrix[i,j]);
minimize total_cost;

% Define the constraints
constraint forall(i in 1..n_stores) (sum(j in 1..n_suppliers) (store_supply[i,j]) = 1); % Each store must be supplied by exactly one warehouse
constraint forall(j in 1..n_suppliers) (sum(i in 1..n_stores) (store_supply[i,j]) <= capacity[j] * warehouse_open[j]); % The number of stores supplied by a warehouse cannot exceed its capacity
constraint forall(i in 1..n_stores, j in 1..n_suppliers) (store_supply[i,j] <= warehouse_open[j]); % A store can only be supplied by an open warehouse

% Solve the problem
solve minimize total_cost;