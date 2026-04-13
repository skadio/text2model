include "globals.mzn";

% Parameters
int: NumberOfFacilities;
int: NumberOfCustomers;

set of int: FACILITIES = 1..NumberOfFacilities;
set of int: CUSTOMERS  = 1..NumberOfCustomers;

array[FACILITIES] of int: FacilityFixedCost;
array[FACILITIES, CUSTOMERS] of int: FacilityToCustomerTransportCost;
array[FACILITIES] of int: FacilityCapacity;
array[CUSTOMERS] of int: CustomerDemand;

% Helpful bounds
int: TotalDemand = sum(c in CUSTOMERS)(CustomerDemand[c]);
int: MaxShip = TotalDemand; % safe upper bound for any shipment quantity

% Variables
array[FACILITIES] of var bool: OpenFacility;

% shipment quantities (integer, nonnegative, bounded)
array[FACILITIES, CUSTOMERS] of var 0..MaxShip: ShipQty;

% Constraints

% Demand satisfaction: each customer's demand must be met exactly
constraint
  forall(c in CUSTOMERS) (
    sum(f in FACILITIES)(ShipQty[f, c]) = CustomerDemand[c]
  );

% Facility capacity: total shipped cannot exceed capacity if opened (else 0)
constraint
  forall(f in FACILITIES) (
    sum(c in CUSTOMERS)(ShipQty[f, c]) <= FacilityCapacity[f] * bool2int(OpenFacility[f])
  );

% Objective
solve minimize
  sum(f in FACILITIES)(FacilityFixedCost[f] * bool2int(OpenFacility[f]))
  + sum(f in FACILITIES, c in CUSTOMERS)(FacilityToCustomerTransportCost[f, c] * ShipQty[f, c]);