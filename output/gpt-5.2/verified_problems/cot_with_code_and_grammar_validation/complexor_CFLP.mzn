int: NumberOfFacilities;
int: NumberOfCustomers;

set of int: FACILITIES = 1..NumberOfFacilities;
set of int: CUSTOMERS = 1..NumberOfCustomers;

array[FACILITIES] of int: FacilityFixedCost;
array[FACILITIES, CUSTOMERS] of int: FacilityToCustomerTransportCost;
array[FACILITIES] of int: FacilityCapacity;
array[CUSTOMERS] of int: CustomerDemand;

array[FACILITIES] of var bool: Open;
array[FACILITIES, CUSTOMERS] of var 0..max(FacilityCapacity): Ship;

constraint forall(j in CUSTOMERS) (
  sum(i in FACILITIES)(Ship[i, j]) = CustomerDemand[j]
);

constraint forall(i in FACILITIES) (
  sum(j in CUSTOMERS)(Ship[i, j]) <= FacilityCapacity[i] * bool2int(Open[i])
);

solve minimize
  sum(i in FACILITIES)(FacilityFixedCost[i] * bool2int(Open[i])) +
  sum(i in FACILITIES, j in CUSTOMERS)(FacilityToCustomerTransportCost[i, j] * Ship[i, j]);