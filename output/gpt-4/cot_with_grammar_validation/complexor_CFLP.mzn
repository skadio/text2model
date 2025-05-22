% Parameters
int: NumberOfFacilities;
int: NumberOfCustomers;
array[1..NumberOfFacilities] of int: FacilityFixedCost;
array[1..NumberOfFacilities, 1..NumberOfCustomers] of int: FacilityToCustomerTransportCost;
array[1..NumberOfFacilities] of int: FacilityCapacity;
array[1..NumberOfCustomers] of int: CustomerDemand;

% Variables
array[1..NumberOfFacilities] of var 0..1: FacilityStatus; % 1 if facility is established, 0 otherwise
array[1..NumberOfFacilities, 1..NumberOfCustomers] of var 0..FacilityCapacity[1..NumberOfFacilities]: FacilityToCustomerSupply; % Amount of goods supplied from each facility to each customer

% Constraints
% Each customer's demand must be met
constraint forall(c in 1..NumberOfCustomers) (
  sum(f in 1..NumberOfFacilities) (FacilityToCustomerSupply[f,c]) = CustomerDemand[c]
);

% A facility cannot supply more than its capacity
constraint forall(f in 1..NumberOfFacilities) (
  sum(c in 1..NumberOfCustomers) (FacilityToCustomerSupply[f,c]) <= FacilityCapacity[f]
);

% A facility can only supply goods if it is established
constraint forall(f in 1..NumberOfFacilities, c in 1..NumberOfCustomers) (
  FacilityToCustomerSupply[f,c] <= FacilityStatus[f] * FacilityCapacity[f]
);

% Objective
% Minimize total cost (fixed cost of establishing facilities + transportation cost)
var int: TotalCost = sum(f in 1..NumberOfFacilities) (FacilityStatus[f] * FacilityFixedCost[f]) + sum(f in 1..NumberOfFacilities, c in 1..NumberOfCustomers) (FacilityToCustomerSupply[f,c] * FacilityToCustomerTransportCost[f,c]);
solve minimize TotalCost;