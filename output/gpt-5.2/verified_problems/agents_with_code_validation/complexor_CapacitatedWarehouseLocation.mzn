include "globals.mzn";

% Parameters
int: NumberOfLocations;
int: NumberOfCustomers;

set of int: LOCATIONS = 1..NumberOfLocations;
set of int: CUSTOMERS = 1..NumberOfCustomers;

array[CUSTOMERS] of int: CustomerDemand;
array[LOCATIONS, CUSTOMERS] of int: ServiceAllocationCost;

array[LOCATIONS] of int: WarehouseCapacity;
array[LOCATIONS] of int: MinimumDemandFromWarehouse;

int: MinimumOpenWarehouses;
int: MaximumOpenWarehouses;

array[LOCATIONS] of int: WarehouseFixedCost;

% Decision variables
array[CUSTOMERS] of var LOCATIONS: assigned;      % warehouse serving customer j
array[LOCATIONS] of var bool: openWarehouse;      % true if warehouse i is opened

% Derived expressions
array[LOCATIONS] of var int: totalDemandServed =
  [ sum(j in CUSTOMERS)(CustomerDemand[j] * bool2int(assigned[j] == i)) | i in LOCATIONS ];

% Constraints

% Open warehouse iff it serves at least one customer
constraint
  forall(i in LOCATIONS)(
    openWarehouse[i] <-> exists(j in CUSTOMERS)(assigned[j] == i)
  );

% Capacity and minimum utilization (only relevant if open)
constraint
  forall(i in LOCATIONS)(
    totalDemandServed[i] <= WarehouseCapacity[i] * bool2int(openWarehouse[i])
  );

constraint
  forall(i in LOCATIONS)(
    totalDemandServed[i] >= MinimumDemandFromWarehouse[i] * bool2int(openWarehouse[i])
  );

% Bounds on number of open warehouses
constraint
  sum(i in LOCATIONS)(bool2int(openWarehouse[i])) >= MinimumOpenWarehouses;

constraint
  sum(i in LOCATIONS)(bool2int(openWarehouse[i])) <= MaximumOpenWarehouses;

% Objective
var int: totalCost =
    sum(j in CUSTOMERS)(
      ServiceAllocationCost[assigned[j], j]
    )
  + sum(i in LOCATIONS)(
      WarehouseFixedCost[i] * bool2int(openWarehouse[i])
    );

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "openWarehouse=", show([bool2int(openWarehouse[i]) | i in LOCATIONS]), "\n",
  "assigned=", show([assigned[j] | j in CUSTOMERS]), "\n"
];