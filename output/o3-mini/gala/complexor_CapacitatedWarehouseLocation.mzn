include "globals.mzn";

% Parameters (provided in .dzn file)
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
% open[i] = 1 if warehouse i is open, 0 otherwise.
array[1..NumberOfLocations] of var 0..1: open;
var 0..NumberOfLocations: OpenCount;
constraint count(open, 1, OpenCount);

% assign[j] indicates the warehouse assigned to customer j.
array[1..NumberOfCustomers] of var 1..NumberOfLocations: assign;

% Linking: If a customer j is assigned to warehouse i, then warehouse i must be open.
constraint forall(j in 1..NumberOfCustomers) (
    open[assign[j]] = 1
);

% For each warehouse, the served demand (only from customers assigned to it)
% must be at most its capacity, and if open, must meet the minimum demand commitment.
constraint forall(i in 1..NumberOfLocations) (
    let {
      var int: servedDemand = sum(j in 1..NumberOfCustomers)( bool2int(assign[j] = i) * CustomerDemand[j] )
    } in
      servedDemand <= WarehouseCapacity[i] * open[i] /\
      servedDemand >= MinimumDemandFromWarehouse[i] * open[i]
);

% Global constraints on the total number of open warehouses.
constraint MinimumOpenWarehouses <= OpenCount /\ OpenCount <= MaximumOpenWarehouses;

% Objective: minimize total cost = fixed cost + service allocation cost.
var int: totalCost = 
  sum(i in 1..NumberOfLocations)( open[i] * WarehouseFixedCost[i] ) + 
  sum(j in 1..NumberOfCustomers)( ServiceAllocationCost[assign[j], j] );

solve minimize totalCost;

output [
  "Total cost = ", show(totalCost), "\n",
  "Open warehouses = ", show(open), "\n",
  "Customer assignments = ", show(assign), "\n"
];