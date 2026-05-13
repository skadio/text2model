% Parameters
int: NumberOfLocations;
int: NumberOfCustomers;
array[1..NumberOfCustomers] of int: CustomerDemand;
array[1..NumberOfLocations, 1..NumberOfCustomers] of int: ServiceAllocationCost;
array[1..NumberOfLocations] of int: WarehouseCapacity;
array[1..NumberOfLocations] of int: MinimumDemandFromWarehouse;
int: MinimumOpenWarehouses;
int: MaximumOpenWarehouses;
array[1..NumberOfLocations] of int: WarehouseFixedCost;

% Variables
array[1..NumberOfLocations] of var 0..1: open;
array[1..NumberOfLocations, 1..NumberOfCustomers] of var 0..1: x;

% Constraints

% Each customer is assigned to exactly one warehouse
constraint
    forall(j in 1..NumberOfCustomers) (
        sum(i in 1..NumberOfLocations) x[i,j] = 1
    );

% Capacity constraints for each warehouse
constraint
    forall(i in 1..NumberOfLocations) (
        sum(j in 1..NumberOfCustomers) CustomerDemand[j] * x[i,j] <= WarehouseCapacity[i]
    );

% Minimum demand served if warehouse is open
constraint
    forall(i in 1..NumberOfLocations) (
        sum(j in 1..NumberOfCustomers) CustomerDemand[j] * x[i,j] >= MinimumDemandFromWarehouse[i] * open[i]
    );

% Open variable dominates assignment
constraint
    forall(i in 1..NumberOfLocations, j in 1..NumberOfCustomers) (
        x[i,j] <= open[i]
    );

% Minimum and maximum number of open warehouses
constraint
    sum(i in 1..NumberOfLocations) open[i] >= MinimumOpenWarehouses /\
    sum(i in 1..NumberOfLocations) open[i] <= MaximumOpenWarehouses;

% Objective
solve minimize
    sum(i in 1..NumberOfLocations) WarehouseFixedCost[i] * open[i] +
    sum(i in 1..NumberOfLocations, j in 1..NumberOfCustomers) ServiceAllocationCost[i,j] * x[i,j];