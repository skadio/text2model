include "globals.mzn";

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

% Decision Variables
array[1..NumberOfLocations, 1..NumberOfCustomers] of var 0..1: service;
array[1..NumberOfLocations] of var 0..1: open;

% Constraints
constraint forall(i in 1..NumberOfLocations) (
    sum(j in 1..NumberOfCustomers) (service[i,j] * CustomerDemand[j]) <= WarehouseCapacity[i] * open[i]
);

constraint forall(i in 1..NumberOfLocations) (
    sum(j in 1..NumberOfCustomers) (service[i,j] * CustomerDemand[j]) >= MinimumDemandFromWarehouse[i] * open[i]
);

constraint forall(j in 1..NumberOfCustomers) (
    sum(i in 1..NumberOfLocations) (service[i,j]) = 1
);

constraint sum(i in 1..NumberOfLocations) (open[i]) >= MinimumOpenWarehouses;
constraint sum(i in 1..NumberOfLocations) (open[i]) <= MaximumOpenWarehouses;

% Objective Function
var int: total_cost = sum(i in 1..NumberOfLocations) (open[i] * WarehouseFixedCost[i]) + sum(i in 1..NumberOfLocations, j in 1..NumberOfCustomers) (service[i,j] * ServiceAllocationCost[i,j] * CustomerDemand[j]);
solve minimize total_cost;

% Output
output [ "Total Cost: " ++ show(total_cost) ++ "\n" ] ++
[ if fix(open[i]) = 1 then "Warehouse " ++ show(i) ++ " is open.\n" else "" endif | i in 1..NumberOfLocations ];