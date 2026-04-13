% Capacitated Warehouse Location Problem

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

% Each customer is assigned to exactly one warehouse
constraint forall(c in CUST) (
  sum(w in LOC)(bool2int(Assign[w,c])) = 1
);

% Can only assign customers to open warehouses
constraint forall(w in LOC, c in CUST) (
  Assign[w,c] -> Open[w]
);

% Capacity and minimum-throughput constraints for open warehouses
constraint forall(w in LOC) (
  let {
    var int: served = sum(c in CUST)(CustomerDemand[c] * bool2int(Assign[w,c]))
  } in
    served <= WarehouseCapacity[w] * bool2int(Open[w]) /\
    served >= MinimumDemandFromWarehouse[w] * bool2int(Open[w])
);

% Minimum/maximum number of open warehouses
constraint sum(w in LOC)(bool2int(Open[w])) >= MinimumOpenWarehouses;
constraint sum(w in LOC)(bool2int(Open[w])) <= MaximumOpenWarehouses;

% Objective: service allocation cost + fixed warehouse operating cost
solve minimize
  sum(w in LOC, c in CUST)(ServiceAllocationCost[w,c] * bool2int(Assign[w,c]))
  + sum(w in LOC)(WarehouseFixedCost[w] * bool2int(Open[w]));