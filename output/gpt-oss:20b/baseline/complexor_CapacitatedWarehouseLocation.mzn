int: NumberOfLocations;
int: NumberOfCustomers;
array[1..NumberOfCustomers] of int: CustomerDemand;
array[1..NumberOfLocations, 1..NumberOfCustomers] of int: ServiceAllocationCost;
array[1..NumberOfLocations] of int: WarehouseCapacity;
array[1..NumberOfLocations] of int: MinimumDemandFromWarehouse;
int: MinimumOpenWarehouses;
int: MaximumOpenWarehouses;
array[1..NumberOfLocations] of int: WarehouseFixedCost;

set of int: Locations = 1..NumberOfLocations;
set of int: Customers = 1..NumberOfCustomers;

var bool: open[Locations];
var bool: assign[Locations, Customers];

constraint
  forall(j in Customers) (
    sum(i in Locations) (assign[i,j]) == 1
  );

constraint
  forall(i in Locations, j in Customers) (
    assign[i,j] <= open[i]
  );

constraint
  forall(i in Locations) (
    sum(j in Customers) (assign[i,j] * CustomerDemand[j]) <= WarehouseCapacity[i]
  );

constraint
  forall(i in Locations) (
    sum(j in Customers) (assign[i,j] * CustomerDemand[j]) >= MinimumDemandFromWarehouse[i] * open[i]
  );

constraint
  sum(i in Locations) (open[i]) >= MinimumOpenWarehouses;

constraint
  sum(i in Locations) (open[i]) <= MaximumOpenWarehouses;

var int: totalCost = sum(i in Locations) (open[i] * WarehouseFixedCost[i]) + 
                     sum(i in Locations, j in Customers) (assign[i,j] * ServiceAllocationCost[i,j]);

solve minimize totalCost;

output [
  "Total cost: ", show(totalCost), "\n",
  "Open warehouses: ", show([i | i in Locations where open[i]]), "\n",
  "Assignments: ", show([ [j | j in Customers where assign[i,j]] | i in Locations]), "\n"
];