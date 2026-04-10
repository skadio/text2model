include "globals.mzn";

int: NumberOfLocations;
int: NumberOfCustomers;

set of int: LOCS = 1..NumberOfLocations;
set of int: CUST = 1..NumberOfCustomers;

array[CUST] of int: CustomerDemand;
array[LOCS, CUST] of int: ServiceAllocationCost;
array[LOCS] of int: WarehouseCapacity;
array[LOCS] of int: MinimumDemandFromWarehouse;
int: MinimumOpenWarehouses;
int: MaximumOpenWarehouses;
array[LOCS] of int: WarehouseFixedCost;

array[LOCS] of var bool: Open;
array[LOCS, CUST] of var bool: Assign;

constraint
  forall(j in CUST) (
    sum(i in LOCS)(bool2int(Assign[i,j])) = 1
  );

constraint
  forall(i in LOCS, j in CUST) (
    Assign[i,j] -> Open[i]
  );

array[LOCS] of var int: ServedDemand =
  [ sum(j in CUST)(CustomerDemand[j] * bool2int(Assign[i,j])) | i in LOCS ];

constraint
  forall(i in LOCS) (
    ServedDemand[i] <= WarehouseCapacity[i] * bool2int(Open[i])
  );

constraint
  forall(i in LOCS) (
    ServedDemand[i] >= MinimumDemandFromWarehouse[i] * bool2int(Open[i])
  );

constraint
  sum(i in LOCS)(bool2int(Open[i])) >= MinimumOpenWarehouses;

constraint
  sum(i in LOCS)(bool2int(Open[i])) <= MaximumOpenWarehouses;

var int: TotalCost =
  sum(i in LOCS, j in CUST)(ServiceAllocationCost[i,j] * bool2int(Assign[i,j]))
  + sum(i in LOCS)(WarehouseFixedCost[i] * bool2int(Open[i]));

solve minimize TotalCost;

output [
  "TotalCost = ", show(TotalCost), "\n",
  "Open = ", show(Open), "\n",
  "ServedDemand = ", show(ServedDemand), "\n"
];