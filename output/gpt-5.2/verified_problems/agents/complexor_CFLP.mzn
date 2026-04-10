% Parameters
int: NumberOfFacilities; % number of potential facilities
int: NumberOfCustomers;  % number of customers

set of int: FACILITIES = 1..NumberOfFacilities;
set of int: CUSTOMERS  = 1..NumberOfCustomers;

array[FACILITIES] of int: FacilityFixedCost; % fixed opening cost per facility
array[FACILITIES, CUSTOMERS] of int: FacilityToCustomerTransportCost; % unit transport cost i->j
array[FACILITIES] of int: FacilityCapacity; % capacity per facility
array[CUSTOMERS] of int: CustomerDemand;    % demand per customer


% Variables
array[FACILITIES] of var bool: OpenFacility; % true if facility is opened

% Amount shipped from facility i to customer j (nonnegative, integer flow)
array[FACILITIES, CUSTOMERS] of var int: ShipQuantity;


% Constraints

%--- Domain constraints for shipment quantities (nonnegative) ---
constraint
  forall(i in FACILITIES, j in CUSTOMERS) (
    ShipQuantity[i,j] >= 0
  );

%--- Demand satisfaction: each customer's demand must be met exactly ---
constraint
  forall(j in CUSTOMERS) (
    sum(i in FACILITIES)(ShipQuantity[i,j]) = CustomerDemand[j]
  );

%--- Facility capacity and opening linkage: shipments allowed only if facility is open ---
constraint
  forall(i in FACILITIES) (
    sum(j in CUSTOMERS)(ShipQuantity[i,j]) <= FacilityCapacity[i] * bool2int(OpenFacility[i])
  );


% Objective
solve minimize
  sum(i in FACILITIES)(
    FacilityFixedCost[i] * bool2int(OpenFacility[i])
  )
  + sum(i in FACILITIES, j in CUSTOMERS)(
    FacilityToCustomerTransportCost[i,j] * ShipQuantity[i,j]
  );