% Parameters
int: NumberOfLocations;
int: NumberOfCustomers;

set of int: LOCATIONS = 1..NumberOfLocations;
set of int: CUSTOMERS  = 1..NumberOfCustomers;

array[CUSTOMERS] of int: CustomerDemand;
array[LOCATIONS, CUSTOMERS] of int: ServiceAllocationCost;
array[LOCATIONS] of int: WarehouseCapacity;
array[LOCATIONS] of int: MinimumDemandFromWarehouse;
int: MinimumOpenWarehouses;
int: MaximumOpenWarehouses;
array[LOCATIONS] of int: WarehouseFixedCost;

% Variables
array[LOCATIONS] of var 0..1: open;                      % 1 if warehouse i is opened
array[LOCATIONS, CUSTOMERS] of var 0..1: assign;         % 1 if customer j served by warehouse i

% Constraints
constraint
   forall(j in CUSTOMERS)(
      sum(i in LOCATIONS)(assign[i,j]) = 1                 % each customer served exactly once
   );

constraint
   forall(i in LOCATIONS, j in CUSTOMERS)(
      assign[i,j] <= open[i]                               % service only from open warehouses
   );

constraint
   forall(i in LOCATIONS)(
      sum(j in CUSTOMERS)(CustomerDemand[j] * assign[i,j]) <= WarehouseCapacity[i]   % capacity
   );

constraint
   forall(i in LOCATIONS)(
      sum(j in CUSTOMERS)(CustomerDemand[j] * assign[i,j]) >=
      MinimumDemandFromWarehouse[i] * open[i]              % minimum load if opened
   );

constraint
   sum(i in LOCATIONS)(open[i]) >= MinimumOpenWarehouses /\   % min number of open warehouses
   sum(i in LOCATIONS)(open[i]) <= MaximumOpenWarehouses;     % max number of open warehouses

% Objective
var int: TotalCost =
      sum(i in LOCATIONS, j in CUSTOMERS)(ServiceAllocationCost[i,j] * assign[i,j])
    + sum(i in LOCATIONS)(WarehouseFixedCost[i] * open[i]);

solve minimize TotalCost;