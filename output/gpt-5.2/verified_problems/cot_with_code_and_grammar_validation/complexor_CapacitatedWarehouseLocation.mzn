int: NumberOfLocations;
int: NumberOfCustomers;

set of int: L = 1..NumberOfLocations;
set of int: C = 1..NumberOfCustomers;

array[C] of int: CustomerDemand;
array[L, C] of int: ServiceAllocationCost;

array[L] of int: WarehouseCapacity;
array[L] of int: MinimumDemandFromWarehouse;

int: MinimumOpenWarehouses;
int: MaximumOpenWarehouses;

array[L] of int: WarehouseFixedCost;

array[L] of var bool: Open;
array[L, C] of var bool: Assign;

constraint
  forall(c in C) (
    sum(l in L)(bool2int(Assign[l, c])) = 1
  );

constraint
  forall(l in L, c in C) (
    bool2int(Assign[l, c]) <= bool2int(Open[l])
  );

constraint
  forall(l in L) (
    sum(c in C)(CustomerDemand[c] * bool2int(Assign[l, c]))
    <= WarehouseCapacity[l] * bool2int(Open[l])
  );

constraint
  forall(l in L) (
    sum(c in C)(CustomerDemand[c] * bool2int(Assign[l, c]))
    >= MinimumDemandFromWarehouse[l] * bool2int(Open[l])
  );

constraint
  sum(l in L)(bool2int(Open[l])) >= MinimumOpenWarehouses;

constraint
  sum(l in L)(bool2int(Open[l])) <= MaximumOpenWarehouses;

solve minimize
  sum(l in L)(WarehouseFixedCost[l] * bool2int(Open[l])) +
  sum(l in L, c in C)(ServiceAllocationCost[l, c] * bool2int(Assign[l, c]));