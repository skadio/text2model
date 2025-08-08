include "globals.mzn";

/* ----- Data ----- */
int: NumberOfLocations;
int: NumberOfCustomers;

array[1..NumberOfCustomers] of int: CustomerDemand;
array[1..NumberOfLocations, 1..NumberOfCustomers] of int: ServiceAllocationCost;
array[1..NumberOfLocations] of int: WarehouseCapacity;
array[1..NumberOfLocations] of int: MinimumDemandFromWarehouse;
int: MinimumOpenWarehouses;
int: MaximumOpenWarehouses;
array[1..NumberOfLocations] of int: WarehouseFixedCost;

/* ----- Decision Variables ----- */
array[1..NumberOfLocations] of var 0..1: open;
array[1..NumberOfLocations, 1..NumberOfCustomers] of var 0..1: assign;
var 0..NumberOfLocations: numOpen;

/* ----- Constraints ----- */

/* Count of opened warehouses */
constraint count(open, 1, numOpen);
constraint MinimumOpenWarehouses <= numOpen;
constraint numOpen <= MaximumOpenWarehouses;

/* Each customer is served by exactly one warehouse */
constraint forall(j in 1..NumberOfCustomers)(
  sum(i in 1..NumberOfLocations) assign[i,j] = 1
);

/* Capacity and minimum demand per warehouse */
constraint forall(i in 1..NumberOfLocations)(
  sum(j in 1..NumberOfCustomers) CustomerDemand[j] * assign[i,j]
    <= WarehouseCapacity[i] * open[i]
  /\ sum(j in 1..NumberOfCustomers) CustomerDemand[j] * assign[i,j]
    >= MinimumDemandFromWarehouse[i] * open[i]
);

/* ----- Objective ----- */
var int: totalAllocationCost =
  sum(i in 1..NumberOfLocations, j in 1..NumberOfCustomers)
    ServiceAllocationCost[i,j] * assign[i,j];

var int: totalFixedCost =
  sum(i in 1..NumberOfLocations) WarehouseFixedCost[i] * open[i];

var int: totalCost = totalAllocationCost + totalFixedCost;

solve minimize totalCost;

/* ----- Output ----- */
output [
  "Total Cost: ", show(totalCost), "\n",
  "Open warehouses: ", show(open), "\n",
  "Assignments: ", show(assign), "\n"
];