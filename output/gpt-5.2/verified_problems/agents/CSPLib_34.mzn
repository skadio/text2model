% Parameters
int: n_suppliers;                         % Number of candidate warehouses (suppliers)
int: n_stores;                            % Number of stores (customers)

int: building_cost;                       % Fixed maintenance/opening cost per warehouse

array[1..n_suppliers] of int: capacity;   % Capacity of each warehouse (max stores it can serve)

array[1..n_stores, 1..n_suppliers] of int: cost_matrix;
% Supply cost for assigning store i to warehouse j

% Variables
array[1..n_suppliers] of var bool: open_warehouse;
% open_warehouse[j] = true if warehouse j is opened

array[1..n_stores, 1..n_suppliers] of var bool: assign;
% assign[i,j] = true if store i is supplied by warehouse j

array[1..n_suppliers] of var 0..n_stores: load;
% load[j] = number of stores assigned to warehouse j

% Constraints

% Each store must be supplied by exactly one warehouse
constraint
  forall(i in 1..n_stores) (
    sum(j in 1..n_suppliers)(bool2int(assign[i,j])) = 1
  );

% Link warehouse load to assignments
constraint
  forall(j in 1..n_suppliers) (
    load[j] = sum(i in 1..n_stores)(bool2int(assign[i,j]))
  );

% Capacity constraints: only open warehouses can serve stores, and load is bounded by capacity
constraint
  forall(j in 1..n_suppliers) (
    load[j] <= capacity[j] * bool2int(open_warehouse[j])
  );

% Assignment implies warehouse is open (redundant but strengthens propagation)
constraint
  forall(i in 1..n_stores, j in 1..n_suppliers) (
    assign[i,j] -> open_warehouse[j]
  );

% Objective
solve minimize
  building_cost * sum(j in 1..n_suppliers)(bool2int(open_warehouse[j]))
  + sum(i in 1..n_stores, j in 1..n_suppliers)(
      cost_matrix[i,j] * bool2int(assign[i,j])
    );