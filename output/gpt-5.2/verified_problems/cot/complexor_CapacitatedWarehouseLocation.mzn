% Parameters
int: NumberOfLocations;
int: NumberOfCustomers;

set of int: LOC = 1..NumberOfLocations;
set of int: CUST = 1..NumberOfCustomers;

array[CUST] of int: CustomerDemand;
array[LOC, CUST] of int: ServiceAllocationCost;
array[LOC] of int: WarehouseCapacity;
array[LOC] of int: MinimumDemandFromWarehouse;
int: MinimumOpenWarehouses;
int: MaximumOpenWarehouses;
array[LOC] of int: WarehouseFixedCost;

% Variables
array[LOC] of var bool: Open;
array[LOC, CUST] of var bool: Assign;

% Constraints
constraint forall(c in CUST)(
  sum(l in LOC)(bool2int(Assign[l,c])) = 1
);

constraint forall(l in LOC, c in CUST)(
  Assign[l,c] -> Open[l]
);

constraint forall(l in LOC)(
  sum(c in CUST)(CustomerDemand[c] * bool2int(Assign[l,c])) <= WarehouseCapacity[l]
);

constraint forall(l in LOC)(
  sum(c in CUST)(CustomerDemand[c] * bool2int(Assign[l,c])) >= MinimumDemandFromWarehouse[l] * bool2int(Open[l])
);

constraint sum(l in LOC)(bool2int(Open[l])) >= MinimumOpenWarehouses;
constraint sum(l in LOC)(bool2int(Open[l])) <= MaximumOpenWarehouses;

% Objective
solve minimize
  sum(l in LOC, c in CUST)(ServiceAllocationCost[l,c] * bool2int(Assign[l,c]))
+ sum(l in LOC)(WarehouseFixedCost[l] * bool2int(Open[l]));