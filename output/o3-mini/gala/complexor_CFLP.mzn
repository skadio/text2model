include "globals.mzn";

% Data declarations (to be provided via a .dzn file)
int: NumberOfFacilities;
int: NumberOfCustomers;
array[1..NumberOfFacilities] of int: FacilityFixedCost;
array[1..NumberOfFacilities, 1..NumberOfCustomers] of int: FacilityToCustomerTransportCost;
array[1..NumberOfFacilities] of int: FacilityCapacity;
array[1..NumberOfCustomers] of int: CustomerDemand;

% Decision variables
% Binary variable indicating if facility i is opened (1) or not (0)
array[1..NumberOfFacilities] of var 0..1: open;

% Flow variable: amount shipped from facility i to customer j.
% Upper bound is chosen as the maximum possible facility capacity.
array[1..NumberOfFacilities, 1..NumberOfCustomers] of var 0..max(FacilityCapacity): flow;

% Constraints

% 1. Demand satisfaction: each customer's demand must be met exactly.
constraint
  forall(j in 1..NumberOfCustomers) (
    sum(i in 1..NumberOfFacilities)(flow[i,j]) = CustomerDemand[j]
  );

% 2. Facility capacity: the total shipment from any facility cannot exceed its capacity if opened,
% and if closed (open[i]=0) then no shipment can be made.
constraint
  forall(i in 1..NumberOfFacilities) (
    sum(j in 1..NumberOfCustomers)(flow[i,j]) <= FacilityCapacity[i] * open[i]
  );

% Objective: minimize the sum of facility fixed costs plus transportation costs.
var int: total_cost =
    sum(i in 1..NumberOfFacilities)(open[i] * FacilityFixedCost[i])
  + sum(i in 1..NumberOfFacilities, j in 1..NumberOfCustomers)(flow[i,j] * FacilityToCustomerTransportCost[i,j]);

solve minimize total_cost;

% Output the total cost, facility open decisions and shipment plan.
output [
  "Total Cost = ", show(total_cost), "\n",
  "Open Facilities = ", show(open), "\n",
  "Shipment Plan: \n", 
  concat([ "Facility ", show(i), ": ", show([ flow[i,j] | j in 1..NumberOfCustomers ]), "\n" | i in 1..NumberOfFacilities])
];