% Parameters
int: NumberOfFacilities;
int: NumberOfCustomers;

set of int: F = 1..NumberOfFacilities;
set of int: C = 1..NumberOfCustomers;

array[F] of int: FacilityFixedCost;
array[F, C] of int: FacilityToCustomerTransportCost;
array[F] of int: FacilityCapacity;
array[C] of int: CustomerDemand;

% Variables
array[F] of var bool: OpenFacility;

int: TotalDemand = sum(c in C)(CustomerDemand[c]);
array[F, C] of var 0..TotalDemand: Ship;

% Constraints
constraint forall(c in C)(
  sum(f in F)(Ship[f, c]) = CustomerDemand[c]
);

constraint forall(f in F)(
  sum(c in C)(Ship[f, c]) <= FacilityCapacity[f] * bool2int(OpenFacility[f])
);

% Objective
var int: TotalCost =
  sum(f in F)(FacilityFixedCost[f] * bool2int(OpenFacility[f])) +
  sum(f in F, c in C)(FacilityToCustomerTransportCost[f, c] * Ship[f, c]);

solve minimize TotalCost;