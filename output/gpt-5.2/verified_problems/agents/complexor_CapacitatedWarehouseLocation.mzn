% Parameters
int: NumberOfLocations; % total number of potential warehouse locations
int: NumberOfCustomers; % total number of customers

set of int: LOCATIONS = 1..NumberOfLocations; % index set for warehouses
set of int: CUSTOMERS = 1..NumberOfCustomers; % index set for customers

array[CUSTOMERS] of int: CustomerDemand; % demand of each customer (assumed non-negative)
array[LOCATIONS, CUSTOMERS] of int: ServiceAllocationCost; % cost to serve customer j from warehouse i

array[LOCATIONS] of int: WarehouseCapacity; % capacity of each warehouse (assumed non-negative)
array[LOCATIONS] of int: MinimumDemandFromWarehouse; % minimum served demand if warehouse is open

int: MinimumOpenWarehouses; % minimum number of warehouses to open
int: MaximumOpenWarehouses; % maximum number of warehouses to open

array[LOCATIONS] of int: WarehouseFixedCost; % fixed cost if warehouse is open


% Variables
array[LOCATIONS] of var 0..1: openWarehouse; % 1 if warehouse i is opened, else 0
array[LOCATIONS, CUSTOMERS] of var 0..1: serve; % 1 if customer j is assigned to warehouse i, else 0
array[LOCATIONS] of var int: totalServedDemand; % total demand served by warehouse i


% Constraints

% Each customer must be served by exactly one warehouse
constraint
  forall(j in CUSTOMERS) (
    sum(i in LOCATIONS)(serve[i,j]) = 1
  );

% Linking: customers can only be assigned to warehouses that are open
constraint
  forall(i in LOCATIONS, j in CUSTOMERS) (
    serve[i,j] <= openWarehouse[i]
  );

% Define total served demand per warehouse based on assignments
constraint
  forall(i in LOCATIONS) (
    totalServedDemand[i] = sum(j in CUSTOMERS)(CustomerDemand[j] * serve[i,j])
  );

% Capacity constraint: served demand cannot exceed warehouse capacity if open
constraint
  forall(i in LOCATIONS) (
    totalServedDemand[i] <= WarehouseCapacity[i] * openWarehouse[i]
  );

% Minimum throughput constraint: if a warehouse is open, it must serve at least a minimum demand
constraint
  forall(i in LOCATIONS) (
    totalServedDemand[i] >= MinimumDemandFromWarehouse[i] * openWarehouse[i]
  );

% Bounds on the number of open warehouses
constraint
  sum(i in LOCATIONS)(openWarehouse[i]) >= MinimumOpenWarehouses;
constraint
  sum(i in LOCATIONS)(openWarehouse[i]) <= MaximumOpenWarehouses;


% Objective
solve minimize
  sum(i in LOCATIONS)(WarehouseFixedCost[i] * openWarehouse[i])
  + sum(i in LOCATIONS, j in CUSTOMERS)(ServiceAllocationCost[i,j] * serve[i,j]);