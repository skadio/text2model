% Parameters
int: NumberOfFacilities; % The number of potential facilities that can be established
int: NumberOfCustomers; % The number of customer zones to be served
array[1..NumberOfFacilities] of int: FacilityFixedCost; % The fixed cost associated with establishing each facility
array[1..NumberOfFacilities, 1..NumberOfCustomers] of int: FacilityToCustomerTransportCost; % The cost of transporting goods from each facility to each customer zone
array[1..NumberOfFacilities] of int: FacilityCapacity; % The capacity of each facility, which limits the amount of goods the facility can handle or produce
array[1..NumberOfCustomers] of int: CustomerDemand; % The demand of each customer zone that must be met by the facilities

% Variables
array[1..NumberOfFacilities] of var 0..1: FacilityStatus; % Binary variable indicating whether a facility is established or not
array[1..NumberOfFacilities, 1..NumberOfCustomers] of var 0..FacilityCapacity[1..NumberOfFacilities]: FacilityToCustomerSupply; % The amount of goods each facility supplies to each customer zone

% Constraints

% Constraint 1: The total supply from each facility should not exceed its capacity
constraint forall(i in 1..NumberOfFacilities) (
  sum(j in 1..NumberOfCustomers) (FacilityToCustomerSupply[i,j]) <= FacilityCapacity[i] * FacilityStatus[i]
);

% Constraint 2: The total supply to each customer should meet its demand
constraint forall(j in 1..NumberOfCustomers) (
  sum(i in 1..NumberOfFacilities) (FacilityToCustomerSupply[i,j]) = CustomerDemand[j]
);

% Constraint 3: If a facility is not established, it cannot supply any goods
constraint forall(i in 1..NumberOfFacilities, j in 1..NumberOfCustomers) (
  FacilityToCustomerSupply[i,j] <= FacilityCapacity[i] * FacilityStatus[i]
);

% Objective
solve minimize sum(i in 1..NumberOfFacilities) (FacilityFixedCost[i] * FacilityStatus[i]) + 
               sum(i in 1..NumberOfFacilities, j in 1..NumberOfCustomers) (FacilityToCustomerTransportCost[i,j] * FacilityToCustomerSupply[i,j]);