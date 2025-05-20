include "globals.mzn";

% Parameters
int: NumberOfFacilities;
int: NumberOfCustomers;
array[1..NumberOfFacilities] of int: FacilityFixedCost;
array[1..NumberOfFacilities, 1..NumberOfCustomers] of int: FacilityToCustomerTransportCost;
array[1..NumberOfFacilities] of int: FacilityCapacity;
array[1..NumberOfCustomers] of int: CustomerDemand;

% Decision Variables
array[1..NumberOfFacilities] of var 0..1: FacilityEstablished; % 1 if facility is established, 0 otherwise
array[1..NumberOfFacilities, 1..NumberOfCustomers] of var 0..FacilityCapacity[i]: FacilityToCustomerSupply; % Amount of goods supplied from each facility to each customer

% Objective
var int: TotalCost = sum(i in 1..NumberOfFacilities) (FacilityEstablished[i] * FacilityFixedCost[i]) + sum(i in 1..NumberOfFacilities, j in 1..NumberOfCustomers) (FacilityToCustomerSupply[i,j] * FacilityToCustomerTransportCost[i,j]);
minimize TotalCost;

% Constraints
constraint forall(i in 1..NumberOfFacilities) (sum(j in 1..NumberOfCustomers) (FacilityToCustomerSupply[i,j]) <= FacilityCapacity[i] * FacilityEstablished[i]); % Capacity constraint
constraint forall(j in 1..NumberOfCustomers) (sum(i in 1..NumberOfFacilities) (FacilityToCustomerSupply[i,j]) = CustomerDemand[j]); % Demand constraint