% Parameters
int: n_suppliers;                        % Number of candidate warehouses (suppliers)
int: n_stores;                           % Number of stores (customers)

int: building_cost;                      % Fixed cost to open a warehouse
array[1..n_suppliers] of int: capacity;  % Capacity of each warehouse (max stores it can serve)

array[1..n_stores, 1..n_suppliers] of int: cost_matrix; % Supply cost from warehouse j to store i


% Variables
array[1..n_suppliers] of var bool: open_warehouse;            % true if warehouse j is opened
array[1..n_stores, 1..n_suppliers] of var bool: assign;       % true if store i is assigned to warehouse j

var int: total_building_cost;            % Total opening cost
var int: total_supply_cost;              % Total supply/assignment cost
var int: total_cost;                     % Total objective cost


% Constraints

% Each store must be supplied by exactly one warehouse
constraint
  forall(i in 1..n_stores) (
    sum(j in 1..n_suppliers)(bool2int(assign[i,j])) = 1
  );

% A store can only be assigned to a warehouse if that warehouse is open
constraint
  forall(i in 1..n_stores, j in 1..n_suppliers) (
    assign[i,j] -> open_warehouse[j]
  );

% Warehouse capacity: number of assigned stores cannot exceed its capacity (if open)
constraint
  forall(j in 1..n_suppliers) (
    sum(i in 1..n_stores)(bool2int(assign[i,j]))
    <= capacity[j] * bool2int(open_warehouse[j])
  );

% Total building cost = fixed opening cost * number of opened warehouses
constraint
  total_building_cost =
    building_cost * sum(j in 1..n_suppliers)(bool2int(open_warehouse[j]));

% Total supply cost = sum of costs for assigned store-warehouse pairs
constraint
  total_supply_cost =
    sum(i in 1..n_stores, j in 1..n_suppliers) (
      cost_matrix[i,j] * bool2int(assign[i,j])
    );

% Total cost = building + supply costs
constraint
  total_cost = total_building_cost + total_supply_cost;


% Objective
solve minimize total_cost;