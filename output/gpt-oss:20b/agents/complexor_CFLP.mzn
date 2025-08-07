include "globals.mzn";

% Data --------------------------------------------------------------
int: NumberOfFacilities;
int: NumberOfCustomers;

array[1..NumberOfFacilities] of int: FacilityFixedCost;
array[1..NumberOfFacilities, 1..NumberOfCustomers] of int: FacilityToCustomerTransportCost;
array[1..NumberOfFacilities] of int: FacilityCapacity;
array[1..NumberOfCustomers] of int: CustomerDemand;

int: totalDemand = sum(CustomerDemand);

% Variables ---------------------------------------------------------
array[1..NumberOfFacilities] of var 0..1: open;  % 1 = facility built

array[1..NumberOfFacilities, 1..NumberOfCustomers] of var 0..totalDemand: flow;

% Constraints -------------------------------------------------------
% Customer demand must be satisfied
constraint forall(j in 1..NumberOfCustomers)(
    sum(i in 1..NumberOfFacilities) (flow[i,j]) == CustomerDemand[j]
);

% Flow from a closed facility must be zero and capacity must not be exceeded
constraint forall(i in 1..NumberOfFacilities)(
    sum(j in 1..NumberOfCustomers) (flow[i,j]) <= FacilityCapacity[i] * open[i]
);

% Objective ---------------------------------------------------------
minimize
    sum(i in 1..NumberOfFacilities) (open[i] * FacilityFixedCost[i])
    +
    sum(i in 1..NumberOfFacilities, j in 1..NumberOfCustomers)
        (flow[i,j] * FacilityToCustomerTransportCost[i,j]);

% Solve -------------------------------------------------------------
solve satisfy;

% Output ------------------------------------------------------------
output [
    "Open facilities: ", show(open), "\n",
    "Flow matrix:    ", show(flow), "\n"
];