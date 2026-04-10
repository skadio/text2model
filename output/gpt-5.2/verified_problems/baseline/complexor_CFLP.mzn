int: NumberOfFacilities;
int: NumberOfCustomers;

set of int: Facilities = 1..NumberOfFacilities;
set of int: Customers  = 1..NumberOfCustomers;

array[Facilities] of int: FacilityFixedCost;
array[Facilities, Customers] of int: FacilityToCustomerTransportCost;
array[Facilities] of int: FacilityCapacity;
array[Customers] of int: CustomerDemand;

% Decision variables
array[Facilities] of var bool: OpenFacility;
array[Facilities, Customers] of var 0..max(CustomerDemand): Ship;

% Demand satisfaction
constraint
  forall(c in Customers)(
    sum(f in Facilities)(Ship[f,c]) = CustomerDemand[c]
  );

% Capacity and linking to open/close
constraint
  forall(f in Facilities)(
    sum(c in Customers)(Ship[f,c]) <= FacilityCapacity[f] * bool2int(OpenFacility[f])
  );

% Objective: fixed opening costs + transport costs
var int: TotalCost =
  sum(f in Facilities)(FacilityFixedCost[f] * bool2int(OpenFacility[f])) +
  sum(f in Facilities, c in Customers)(FacilityToCustomerTransportCost[f,c] * Ship[f,c]);

solve minimize TotalCost;

output [
  "TotalCost=", show(TotalCost), "\n",
  "OpenFacility=", show(OpenFacility), "\n",
  "Ship=\n"
] ++
[
  if c = 1 then "" else "" endif ++
  concat([ show(Ship[f,c]) ++ if f = NumberOfFacilities then "\n" else " " endif
        | f in Facilities ])
  | c in Customers
];