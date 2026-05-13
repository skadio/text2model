% Parameters
int: NumberOfFacilities;
int: NumberOfCustomers;
array[1..NumberOfFacilities] of int: FacilityFixedCost;
array[1..NumberOfFacilities, 1..NumberOfCustomers] of int: FacilityToCustomerTransportCost;
array[1..NumberOfFacilities] of int: FacilityCapacity;
array[1..NumberOfCustomers] of int: CustomerDemand;
int: maxCap = max(FacilityCapacity);

% Variables
array[1..NumberOfFacilities] of var 0..1: open;
array[1..NumberOfFacilities, 1..NumberOfCustomers] of var 0..maxCap: supply;

% Constraints
constraint forall(i in 1..NumberOfFacilities, j in 1..NumberOfCustomers) (
    supply[i,j] <= FacilityCapacity[i] * open[i]
);
constraint forall(i in 1..NumberOfFacilities) (
    sum(j in 1..NumberOfCustomers) supply[i,j] <= FacilityCapacity[i] * open[i]
);
constraint forall(j in 1..NumberOfCustomers) (
    sum(i in 1..NumberOfFacilities) supply[i,j] = CustomerDemand[j]
);

% Objective
var int: totalCost = sum(i in 1..NumberOfFacilities) FacilityFixedCost[i] * open[i] +
                     sum(i in 1..NumberOfFacilities, j in 1..NumberOfCustomers) FacilityToCustomerTransportCost[i,j] * supply[i,j];
solve minimize totalCost;