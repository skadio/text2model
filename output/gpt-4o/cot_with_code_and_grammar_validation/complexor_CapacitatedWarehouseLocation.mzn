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
array[LOCATIONS] of var 0..1: open;                         % 1 if warehouse l is opened
array[LOCATIONS, CUSTOMERS] of var 0..1: assign;            % 1 if customer c served by warehouse l

% Constraints
%
% Every customer must be assigned to exactly one warehouse
constraint
  forall(c in CUSTOMERS)(
    sum(l in LOCATIONS)(assign[l,c]) = 1
  );

% A customer can only be served by an opened warehouse
constraint
  forall(l in LOCATIONS, c in CUSTOMERS)(
    assign[l,c] <= open[l]
  );

% Capacity upper bound for every opened warehouse
constraint
  forall(l in LOCATIONS)(
    sum(c in CUSTOMERS)(CustomerDemand[c] * assign[l,c]) <= WarehouseCapacity[l] * open[l]
  );

% Minimum demand requirement for every opened warehouse
constraint
  forall(l in LOCATIONS)(
    sum(c in CUSTOMERS)(CustomerDemand[c] * assign[l,c]) >= MinimumDemandFromWarehouse[l] * open[l]
  );

% Bounds on the total number of open warehouses
constraint
  MinimumOpenWarehouses <= sum(l in LOCATIONS)(open[l]);
constraint
  sum(l in LOCATIONS)(open[l]) <= MaximumOpenWarehouses;

% Objective
var int: total_cost =
      sum(l in LOCATIONS, c in CUSTOMERS)(
        ServiceAllocationCost[l,c] * assign[l,c]
      )
    + sum(l in LOCATIONS)(
        WarehouseFixedCost[l] * open[l]
      );

solve minimize total_cost;