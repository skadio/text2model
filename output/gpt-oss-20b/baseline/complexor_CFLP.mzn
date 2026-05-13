% Capacitated Facility Location Model
% -----------------------------------

int: NumberOfFacilities;
int: NumberOfCustomers;

array[1..NumberOfFacilities] of int: FacilityFixedCost;
array[1..NumberOfFacilities, 1..NumberOfCustomers] of int: FacilityToCustomerTransportCost;
array[1..NumberOfFacilities] of int: FacilityCapacity;
array[1..NumberOfCustomers] of int: CustomerDemand;

set of int: Facilities = 1..NumberOfFacilities;
set of int: Customers = 1..NumberOfCustomers;

% Decision variables
var bool: open[Facilities];
var int: supply[Facilities, Customers] >= 0;

% Capacity constraints
constraint
  forall(i in Facilities) (
    sum(j in Customers)(supply[i,j]) <= FacilityCapacity[i] * (if open[i] then 1 else 0)
  );

% Demand satisfaction constraints
constraint
  forall(j in Customers) (
    sum(i in Facilities)(supply[i,j]) == CustomerDemand[j]
  );

% Objective: minimize total cost
var int: totalFixedCost = sum(i in Facilities)(FacilityFixedCost[i] * (if open[i] then 1 else 0));
var int: totalTransportCost = sum(i in Facilities, j in Customers)(FacilityToCustomerTransportCost[i,j] * supply[i,j]);

var int: totalCost = totalFixedCost + totalTransportCost;

solve minimize totalCost;

% Output
output [
  "Total Cost: ", show(totalCost), "\n",
  "Open Facilities: ", show([i | i in Facilities where open[i] = true]), "\n",
  "Supply Matrix:\n",
  concat([ show([supply[i,j] | j in Customers]) ++ "\n" | i in Facilities ])
];