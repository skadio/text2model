% Input parameters
int: n_suppliers; % Number of warehouse candidates
int: n_stores; % Number of stores
int: building_cost; % Cost of opening a warehouse
array[1..n_suppliers] of int: capacity; % Capacity of each warehouse
array[1..n_stores, 1..n_suppliers] of int: cost_matrix; % Cost of a store being supplied by a warehouse

% Decision variables
array[1..n_suppliers] of var 0..1: open; % Whether each warehouse is open
array[1..n_stores, 1..n_suppliers] of var 0..1: supply; % Whether each store is supplied by each warehouse

% Constraints
constraint forall(i in 1..n_stores)(
  sum(j in 1..n_suppliers)(supply[i,j]) = 1 % Each store must be supplied by exactly one warehouse
);

constraint forall(j in 1..n_suppliers)(
  sum(i in 1..n_stores)(supply[i,j]) <= capacity[j]*open[j] % The total supply from a warehouse cannot exceed its capacity
);

% Objective function
var int: total_cost = sum(i in 1..n_stores, j in 1..n_suppliers)(supply[i,j]*cost_matrix[i,j]) + sum(j in 1..n_suppliers)(open[j]*building_cost);
solve minimize total_cost;

% Output
output [ "Total cost: ", show(total_cost), "\n",
          "Open warehouses: ", show(open), "\n",
          "Supply matrix: ", show(supply) ];