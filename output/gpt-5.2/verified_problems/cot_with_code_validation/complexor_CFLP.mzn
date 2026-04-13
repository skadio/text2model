% Capacitated Facility Location Problem (CFLP)

% Parameters (provided in .dzn)
int: NumberOfFacilities;
int: NumberOfCustomers;

set of int: Facilities = 1..NumberOfFacilities;
set of int: Customers  = 1..NumberOfCustomers;

array[Facilities] of int: FacilityFixedCost;
array[Facilities, Customers] of int: FacilityToCustomerTransportCost;
array[Facilities] of int: FacilityCapacity;
array[Customers] of int: CustomerDemand;

% Variables
array[Facilities] of var bool: OpenFacility;

int: MaxDemand = max(CustomerDemand);
array[Facilities, Customers] of var 0..MaxDemand: Ship;

var int: TotalCost;

% Basic data sanity (non-negative)
constraint forall(i in Facilities) (FacilityFixedCost[i] >= 0 /\ FacilityCapacity[i] >= 0);
constraint forall(j in Customers) (CustomerDemand[j] >= 0);
constraint forall(i in Facilities, j in Customers) (FacilityToCustomerTransportCost[i, j] >= 0);

% Demand satisfaction
constraint
  forall(j in Customers) (
    sum(i in Facilities)(Ship[i, j]) = CustomerDemand[j]
  );

% Facility capacity and linking to opening decision
constraint
  forall(i in Facilities) (
    sum(j in Customers)(Ship[i, j]) <= FacilityCapacity[i] * bool2int(OpenFacility[i])
  );

% Objective definition
constraint
  TotalCost =
    sum(i in Facilities)(FacilityFixedCost[i] * bool2int(OpenFacility[i])) +
    sum(i in Facilities, j in Customers)(FacilityToCustomerTransportCost[i, j] * Ship[i, j]);

solve minimize TotalCost;

output [
  "TotalCost=", show(TotalCost), "\n",
  "OpenFacility=", show([bool2int(OpenFacility[i]) | i in Facilities]), "\n"
];