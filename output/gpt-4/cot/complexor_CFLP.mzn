% Parameters
int: NumberOfFacilities;
int: NumberOfCustomers;
array[1..NumberOfFacilities] of int: FacilityFixedCost;
array[1..NumberOfFacilities, 1..NumberOfCustomers] of int: FacilityToCustomerTransportCost;
array[1..NumberOfFacilities] of int: FacilityCapacity;
array[1..NumberOfCustomers] of int: CustomerDemand;

% Variables
array[1..NumberOfFacilities] of var 0..1: FacilityStatus; % 1 if facility is established, 0 otherwise
array[1..NumberOfFacilities, 1..NumberOfCustomers] of var 0..max(FacilityCapacity): Supply; % Amount of goods supplied by each facility to each customer

% Constraints
% Each customer's demand must be met
constraint forall(c in 1..NumberOfCustomers) (
  sum(f in 1..NumberOfFacilities) (Supply[f,c]) = CustomerDemand[c]
);

% A facility cannot supply more than its capacity
constraint forall(f in 1..NumberOfFacilities) (
  sum(c in 1..NumberOfCustomers) (Supply[f,c]) <= FacilityCapacity[f] * FacilityStatus[f]
);

% Objective
var int: TotalCost = sum(f in 1..NumberOfFacilities) (FacilityFixedCost[f] * FacilityStatus[f]) + sum(f in 1..NumberOfFacilities, c in 1..NumberOfCustomers) (FacilityToCustomerTransportCost[f,c] * Supply[f,c]);
solve minimize TotalCost;