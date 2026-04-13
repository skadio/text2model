include "globals.mzn";

%----------------------%
% Input data (from .dzn)
%----------------------%
int: NumberOfLocations;
int: NumberOfCustomers;

array[1..NumberOfCustomers] of int: CustomerDemand;
array[1..NumberOfLocations, 1..NumberOfCustomers] of int: ServiceAllocationCost;

array[1..NumberOfLocations] of int: WarehouseCapacity;
array[1..NumberOfLocations] of int: MinimumDemandFromWarehouse;

int: MinimumOpenWarehouses;
int: MaximumOpenWarehouses;

array[1..NumberOfLocations] of int: WarehouseFixedCost;

%----------------------%
% Decision variables
%----------------------%
array[1..NumberOfLocations] of var bool: open;

% assign[c] = location serving customer c
array[1..NumberOfCustomers] of var 1..NumberOfLocations: assign;

% Derived: whether location l serves customer c
array[1..NumberOfLocations, 1..NumberOfCustomers] of var bool: serves =
  array2d(1..NumberOfLocations, 1..NumberOfCustomers,
          [assign[c] == l | l in 1..NumberOfLocations, c in 1..NumberOfCustomers]);

% Total demand served by each warehouse
array[1..NumberOfLocations] of var 0..sum(CustomerDemand): load;

%----------------------%
% Constraints
%----------------------%

% Load definition and capacity / minimum-load-if-open
constraint
  forall(l in 1..NumberOfLocations) (
    load[l] = sum(c in 1..NumberOfCustomers)(CustomerDemand[c] * bool2int(serves[l,c])) /\
    load[l] <= WarehouseCapacity[l] * bool2int(open[l]) /\
    load[l] >= MinimumDemandFromWarehouse[l] * bool2int(open[l])
  );

% If any customer assigned to l, then l must be open
constraint
  forall(c in 1..NumberOfCustomers) (
    open[assign[c]]
  );

% Min/max number of open warehouses (hint: count)
var 0..NumberOfLocations: numOpen;
constraint count(open, true, numOpen);
constraint numOpen >= MinimumOpenWarehouses;
constraint numOpen <= MaximumOpenWarehouses;

%----------------------%
% Objective
%----------------------%
var int: totalServiceCost =
  sum(c in 1..NumberOfCustomers)(ServiceAllocationCost[assign[c], c]);

var int: totalFixedCost =
  sum(l in 1..NumberOfLocations)(WarehouseFixedCost[l] * bool2int(open[l]));

var int: totalCost = totalServiceCost + totalFixedCost;

solve minimize totalCost;

%----------------------%
% Output
%----------------------%
output [
  "TotalCost = ", show(totalCost), "\n",
  "ServiceCost = ", show(totalServiceCost), "\n",
  "FixedCost = ", show(totalFixedCost), "\n",
  "Open = ", show(open), "\n",
  "NumOpen = ", show(numOpen), "\n",
  "Assign = ", show(assign), "\n",
  "Load = ", show(load), "\n"
];