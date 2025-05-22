% Parameters
int: NumberOfFacilities;
int: NumberOfCustomers;

set of int: Facilities = 1..NumberOfFacilities;
set of int: Customers  = 1..NumberOfCustomers;

array[Facilities] of int: FacilityFixedCost;
array[Facilities, Customers] of int: FacilityToCustomerTransportCost;
array[Facilities] of int: FacilityCapacity;
array[Customers] of int: CustomerDemand;

int: TotalDemand = sum(c in Customers)(CustomerDemand[c]);

% Variables
array[Facilities] of var bool: Open;
array[Facilities, Customers] of var 0..TotalDemand: Ship;

% Constraints
constraint
  forall(c in Customers)(
    sum(f in Facilities)(Ship[f,c]) = CustomerDemand[c]
  );

constraint
  forall(f in Facilities)(
    sum(c in Customers)(Ship[f,c]) <= FacilityCapacity[f] * bool2int(Open[f])
  );

constraint
  forall(f in Facilities, c in Customers)(
    Ship[f,c] <= CustomerDemand[c] * bool2int(Open[f])
  );

% Objective
var int: TotalCost =
    sum(f in Facilities)(FacilityFixedCost[f] * bool2int(Open[f])) +
    sum(f in Facilities, c in Customers)(
        FacilityToCustomerTransportCost[f,c] * Ship[f,c]
    );

solve minimize TotalCost;