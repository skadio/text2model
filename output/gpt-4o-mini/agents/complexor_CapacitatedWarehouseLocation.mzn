include "globals.mzn";

int: NumberOfLocations;                     % Total number of potential warehouse locations
int: NumberOfCustomers;                     % Total number of customers to be serviced
array[1..NumberOfCustomers] of int: CustomerDemand; % Demand of each customer
array[1..NumberOfLocations, 1..NumberOfCustomers] of int: ServiceAllocationCost; % Cost of allocating service
array[1..NumberOfLocations] of int: WarehouseCapacity; % Total capacity for each warehouse
array[1..NumberOfLocations] of int: MinimumDemandFromWarehouse; % Lower limit on demand from a warehouse
int: MinimumOpenWarehouses;                 % Minimum number of warehouses that need to be operational
int: MaximumOpenWarehouses;                 % Maximum number of warehouses that can be operational
array[1..NumberOfLocations] of int: WarehouseFixedCost; % Fixed operating cost of each warehouse

/* Decision Variables */
array[1..NumberOfLocations] of var 0..1: open; % 1 if warehouse is open, 0 otherwise
array[1..NumberOfLocations, 1..NumberOfCustomers] of var 0..1: allocate; % 1 if customer is allocated to warehouse, 0 otherwise

/* Constraints */
% Ensure that the demand from each warehouse does not exceed its capacity
constraint forall(j in 1..NumberOfLocations)(
    sum(i in 1..NumberOfCustomers)(allocate[j, i] * CustomerDemand[i]) <= WarehouseCapacity[j]
);

% Ensure that the minimum demand is met if a warehouse is open
constraint forall(j in 1..NumberOfLocations)(
    open[j] = 1 -> sum(i in 1..NumberOfCustomers)(allocate[j, i] * CustomerDemand[i]) >= MinimumDemandFromWarehouse[j]
);

% Ensure that the total demand allocated to each warehouse does not exceed its capacity
constraint forall(i in 1..NumberOfCustomers)(
    sum(j in 1..NumberOfLocations)(allocate[j, i]) = 1 % Each customer must be allocated to exactly one warehouse
);

/* Count the number of open warehouses */
var 0..NumberOfLocations: numOpenWarehouses;
constraint numOpenWarehouses = sum(j in 1..NumberOfLocations)(open[j]);

% Ensure the number of open warehouses is within the specified limits
constraint numOpenWarehouses >= MinimumOpenWarehouses;
constraint numOpenWarehouses <= MaximumOpenWarehouses;

/* Objective Function */
var int: totalCost = sum(j in 1..NumberOfLocations)(WarehouseFixedCost[j] * open[j]) + 
                     sum(j in 1..NumberOfLocations, i in 1..NumberOfCustomers)(ServiceAllocationCost[j, i] * allocate[j, i]);

solve minimize totalCost;

/* Output */
output [
    "Total Cost = ", show(totalCost), "\n",
    "Open Warehouses = ", show(open), "\n",
    "Allocations = ", show(allocate), "\n"
];