% Parameters
int: NumberOfFacilities;
int: NumberOfCustomers;

array [1..NumberOfFacilities] of int: FacilityFixedCost;
array [1..NumberOfFacilities, 1..NumberOfCustomers] of int: FacilityToCustomerTransportCost;
array [1..NumberOfFacilities] of int: FacilityCapacity;
array [1..NumberOfCustomers] of int: CustomerDemand;

set of int: Facility = 1..NumberOfFacilities;
set of int: Customer = 1..NumberOfCustomers;

int: MaxDemand = max(CustomerDemand);

% Variables
array [Facility] of var 0..1: OpenFacility;
array [Facility, Customer] of var 0..MaxDemand: Flow;

% Constraints
constraint
    forall(c in Customer)(
        sum(f in Facility)(Flow[f, c]) = CustomerDemand[c]
    );

constraint
    forall(f in Facility)(
        sum(c in Customer)(Flow[f, c]) <= FacilityCapacity[f] * OpenFacility[f]
    );

constraint
    forall(f in Facility, c in Customer)(
        Flow[f, c] <= CustomerDemand[c]
    );

% Objective
var int: TotalCost = 
    sum(f in Facility)(FacilityFixedCost[f] * OpenFacility[f]) +
    sum(f in Facility, c in Customer)(FacilityToCustomerTransportCost[f, c] * Flow[f, c]);

solve minimize TotalCost;