include "globals.mzn";

int: NumberOfFacilities;  % Number of potential facilities
int: NumberOfCustomers;    % Number of customer zones
array[1..NumberOfFacilities] of int: FacilityFixedCost;  % Fixed cost for each facility
array[1..NumberOfFacilities, 1..NumberOfCustomers] of int: FacilityToCustomerTransportCost;  % Transport costs
array[1..NumberOfFacilities] of int: FacilityCapacity;  % Capacity of each facility
array[1..NumberOfCustomers] of int: CustomerDemand;  % Demand of each customer zone

% Decision variables
array[1..NumberOfFacilities] of var 0..1: open;  % 1 if facility is opened, 0 otherwise
array[1..NumberOfFacilities, 1..NumberOfCustomers] of var 0..int: supply;  % Amount supplied from facility to customer

% Objective: Minimize total cost
var int: totalCost = sum(i in 1..NumberOfFacilities)(FacilityFixedCost[i] * open[i]) +
                     sum(i in 1..NumberOfFacilities, j in 1..NumberOfCustomers)(FacilityToCustomerTransportCost[i,j] * supply[i,j]);

% Constraints
% Each customer's demand must be met
constraint forall(j in 1..NumberOfCustomers)(
    sum(i in 1..NumberOfFacilities)(supply[i,j]) >= CustomerDemand[j]
);

% Each facility's supply cannot exceed its capacity
constraint forall(i in 1..NumberOfFacilities)(
    sum(j in 1..NumberOfCustomers)(supply[i,j]) <= FacilityCapacity[i] * open[i]
);

% Solve the model
solve minimize totalCost;

% Output the results
output [
    "Total Cost = ", show(totalCost), "\n",
    "Facilities Opened = ", show([i | i in 1..NumberOfFacilities where open[i] == 1]), "\n",
    "Supply Matrix = ", show(supply), "\n"
];