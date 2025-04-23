% Parameters
int: n_suppliers; % Number of warehouse candidates
int: n_stores; % Number of stores
int: building_cost; % Cost of opening a warehouse
array[1..n_suppliers] of int: capacity; % Array containing the capacity of each warehouse
array[1..n_stores, 1..n_suppliers] of int: cost_matrix; % Cost matrix where each element represents the cost of a store being supplied by a warehouse

% Variables
array[1..n_suppliers] of var 0..1: open_warehouse; % Binary variable indicating whether a warehouse is open or not
array[1..n_stores, 1..n_suppliers] of var 0..1: supply; % Binary variable indicating whether a store is supplied by a warehouse or not

% Constraints

% Each store must be supplied by exactly one warehouse
constraint forall(i in 1..n_stores)(
  sum(j in 1..n_suppliers)(supply[i,j]) = 1
);

% A warehouse can only supply a store if it is open
constraint forall(i in 1..n_stores, j in 1..n_suppliers)(
  supply[i,j] <= open_warehouse[j]
);

% The total number of stores supplied by a warehouse cannot exceed its capacity
constraint forall(j in 1..n_suppliers)(
  sum(i in 1..n_stores)(supply[i,j]) <= capacity[j]
);

% If a warehouse is not open, it cannot supply any store
constraint forall(j in 1..n_suppliers)(
  if open_warehouse[j] = 0 then
    sum(i in 1..n_stores)(supply[i,j]) = 0
  endif
);

% Objective
solve minimize sum(j in 1..n_suppliers)(open_warehouse[j]*building_cost) + sum(i in 1..n_stores, j in 1..n_suppliers)(supply[i,j]*cost_matrix[i,j]);