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
array[1..NumberOfLocations, 1..NumberOfCustomers] of var 0..1: ServiceAllocation;
array[1..NumberOfLocations] of var 0..1: OpenWarehouse;

% Constraints
constraint forall(i in 1..NumberOfLocations)(sum(j in 1..NumberOfCustomers)(ServiceAllocation[i,j]*CustomerDemand[j]) <= WarehouseCapacity[i]*OpenWarehouse[i]);
constraint forall(i in 1..NumberOfLocations)(sum(j in 1..NumberOfCustomers)(ServiceAllocation[i,j]*CustomerDemand[j]) >= MinimumDemandFromWarehouse[i]*OpenWarehouse[i]);
constraint forall(j in 1..NumberOfCustomers)(sum(i in 1..NumberOfLocations)(ServiceAllocation[i,j]) = 1);
constraint sum(i in 1..NumberOfLocations)(OpenWarehouse[i]) >= MinimumOpenWarehouses;
constraint sum(i in 1..NumberOfLocations)(OpenWarehouse[i]) <= MaximumOpenWarehouses;

% Objective
var int: TotalCost = sum(i in 1..NumberOfLocations, j in 1..NumberOfCustomers)(ServiceAllocation[i,j]*ServiceAllocationCost[i,j]) + sum(i in 1..NumberOfLocations)(OpenWarehouse[i]*WarehouseFixedCost[i]);
solve minimize TotalCost;