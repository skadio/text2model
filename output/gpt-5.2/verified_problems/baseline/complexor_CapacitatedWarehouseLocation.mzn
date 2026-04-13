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

array[LOC] of var bool: open;
array[LOC, CUST] of var bool: serve;

constraint
  forall(c in CUST)(
    sum(l in LOC)(bool2int(serve[l,c])) = 1
  );

constraint
  forall(l in LOC, c in CUST)(
    serve[l,c] -> open[l]
  );

array[LOC] of var int: served_demand =
  [ sum(c in CUST)(CustomerDemand[c] * bool2int(serve[l,c])) | l in LOC ];

constraint
  forall(l in LOC)(
    served_demand[l] <= WarehouseCapacity[l] * bool2int(open[l])
  );

constraint
  forall(l in LOC)(
    served_demand[l] >= MinimumDemandFromWarehouse[l] * bool2int(open[l])
  );

constraint
  sum(l in LOC)(bool2int(open[l])) >= MinimumOpenWarehouses /\
  sum(l in LOC)(bool2int(open[l])) <= MaximumOpenWarehouses;

var int: total_cost =
  sum(l in LOC)(WarehouseFixedCost[l] * bool2int(open[l])) +
  sum(l in LOC, c in CUST)(ServiceAllocationCost[l,c] * bool2int(serve[l,c]));

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "open=", show([ bool2int(open[l]) | l in LOC ]), "\n",
  "served_demand=", show([ served_demand[l] | l in LOC ]), "\n"
];