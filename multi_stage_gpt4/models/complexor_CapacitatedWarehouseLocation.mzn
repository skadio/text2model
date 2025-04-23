% Parameters
int: NumberOfLocations; % The total number of potential warehouse locations
int: NumberOfCustomers; % The total number of customers to be serviced
array[1..NumberOfCustomers] of int: CustomerDemand; % The demand of each customer
array[1..NumberOfLocations, 1..NumberOfCustomers] of int: ServiceAllocationCost; % The cost of allocating service from each warehouse to each customer
array[1..NumberOfLocations] of int: WarehouseCapacity; % The total capacity for each warehouse
array[1..NumberOfLocations] of int: MinimumDemandFromWarehouse; % The lower limit on the demand that must be met from a warehouse if it is operational
int: MinimumOpenWarehouses; % The minimum number of warehouses that need to be operational
int: MaximumOpenWarehouses; % The maximum number of warehouses that can be operational
array[1..NumberOfLocations] of int: WarehouseFixedCost; % The fixed operating cost of each warehouse

% Variables
array[1..NumberOfLocations, 1..NumberOfCustomers] of var 0..1: ServiceAllocation; % Binary variable indicating if a warehouse is servicing a customer
array[1..NumberOfLocations] of var 0..1: WarehouseOpen; % Binary variable indicating if a warehouse is open

% Constraints

% Constraint 1: The total demand met by each warehouse should not exceed its capacity
constraint forall(i in 1..NumberOfLocations) (
    sum(j in 1..NumberOfCustomers) (ServiceAllocation[i,j] * CustomerDemand[j]) <= WarehouseCapacity[i] * WarehouseOpen[i]
);

% Constraint 2: If a warehouse is open, it should meet at least the minimum demand
constraint forall(i in 1..NumberOfLocations) (
    sum(j in 1..NumberOfCustomers) (ServiceAllocation[i,j] * CustomerDemand[j]) >= MinimumDemandFromWarehouse[i] * WarehouseOpen[i]
);

% Constraint 3: Each customer's demand must be met by exactly one warehouse
constraint forall(j in 1..NumberOfCustomers) (
    sum(i in 1..NumberOfLocations) (ServiceAllocation[i,j]) = 1
);

% Constraint 4: The number of open warehouses should be between the minimum and maximum limits
constraint sum(i in 1..NumberOfLocations) (WarehouseOpen[i]) >= MinimumOpenWarehouses;
constraint sum(i in 1..NumberOfLocations) (WarehouseOpen[i]) <= MaximumOpenWarehouses;

% Constraint 5: If a warehouse is not open, it cannot service any customer
constraint forall(i in 1..NumberOfLocations, j in 1..NumberOfCustomers) (
    ServiceAllocation[i,j] <= WarehouseOpen[i]
);

% Objective
solve minimize sum(i in 1..NumberOfLocations) (WarehouseFixedCost[i] * WarehouseOpen[i]) + 
               sum(i in 1..NumberOfLocations, j in 1..NumberOfCustomers) (ServiceAllocationCost[i,j] * ServiceAllocation[i,j]);