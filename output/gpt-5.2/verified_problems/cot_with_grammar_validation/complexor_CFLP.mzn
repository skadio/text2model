int: NumberOfFacilities;
int: NumberOfCustomers;

set of int: FACILITIES = 1..NumberOfFacilities;
set of int: CUSTOMERS = 1..NumberOfCustomers;

array[FACILITIES] of int: FacilityFixedCost;
array[FACILITIES, CUSTOMERS] of int: FacilityToCustomerTransportCost;
array[FACILITIES] of int: FacilityCapacity;
array[CUSTOMERS] of int: CustomerDemand;

array[FACILITIES] of var 0..1: OpenFacility;

int: TotalDemand = sum(c in CUSTOMERS)(CustomerDemand[c]);
int: MaxCap = max([FacilityCapacity[f] | f in FACILITIES]);
int: MaxShip = min(MaxCap, TotalDemand);

array[FACILITIES, CUSTOMERS] of var 0..MaxShip: Ship;

var 0..(
  sum(f in FACILITIES)(FacilityFixedCost[f]) +
  sum(f in FACILITIES, c in CUSTOMERS)(FacilityToCustomerTransportCost[f, c] * MaxShip)
): TotalCost;

constraint forall(c in CUSTOMERS)(
  sum(f in FACILITIES)(Ship[f, c]) = CustomerDemand[c]
);

constraint forall(f in FACILITIES)(
  sum(c in CUSTOMERS)(Ship[f, c]) <= FacilityCapacity[f] * OpenFacility[f]
);

constraint TotalCost =
  sum(f in FACILITIES)(FacilityFixedCost[f] * OpenFacility[f]) +
  sum(f in FACILITIES, c in CUSTOMERS)(FacilityToCustomerTransportCost[f, c] * Ship[f, c]);

solve minimize TotalCost;