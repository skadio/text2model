% Empty model file% ============================================================
% CAPACITATED FACILITY LOCATION PROBLEM
% ============================================================
%
% DESCRIPTION:
%  The problem involves selecting a subset of potential facilities to open
%  and assigning shipments from these facilities to customer zones such that:
%    - Each customer zone's demand is fully met.
%    - The total shipment from a facility does not exceed its capacity,
%      and a facility can only ship if it is opened.
%    - A fixed cost is incurred for each facility that is opened,
%      in addition to transportation costs for shipping goods.
%
% OBJECTIVE:
%  Minimize the total cost, which is the sum of the fixed operating costs of
%  the open facilities and the transportation costs for servicing all customers.
%
% PARAMETERS (provided via input.json):
%   - NumberOfFacilities: The number of potential facilities.
%   - NumberOfCustomers: The number of customer zones.
%   - FacilityFixedCost: Fixed cost for establishing each facility.
%   - FacilityToCustomerTransportCost: Cost to transport goods from each facility to each customer.
%   - FacilityCapacity: The maximum capacity for each facility.
%   - CustomerDemand: The demand for each customer zone.
%
% OUTPUT:
%   - FacilityOpen: Binary array (of length NumberOfFacilities) indicating if a facility is open (1) or closed (0).
%   - CustomerAssignment: Matrix (NumberOfFacilities x NumberOfCustomers) showing the quantity shipped from facility i to customer j.
%   - TotalCost: The total cost of the solution.
%
% ============================================================


% -----------------------------
% 1) PARAMETERS
% -----------------------------
int: NumberOfFacilities;
int: NumberOfCustomers;

array[1..NumberOfFacilities] of int: FacilityFixedCost;
array[1..NumberOfFacilities, 1..NumberOfCustomers] of int: FacilityToCustomerTransportCost;
array[1..NumberOfFacilities] of int: FacilityCapacity;
array[1..NumberOfCustomers] of int: CustomerDemand;

% To bound shipment variables, we can use the maximum customer demand.
int: MaxDemand = max(CustomerDemand);


% -----------------------------
% 2) DECISION VARIABLES
% -----------------------------
% FacilityOpen[i] = 1 if facility i is opened, 0 otherwise.
array[1..NumberOfFacilities] of var 0..1: FacilityOpen;

% CustomerAssignment[i,j] = quantity shipped from facility i to customer j.
% Each shipment is an integer in the range 0..MaxDemand.
array[1..NumberOfFacilities, 1..NumberOfCustomers] of var 0..MaxDemand: CustomerAssignment;

% TotalCost: The total cost of the solution.
var int: TotalCost;


% -----------------------------
% 3) CONSTRAINTS
% -----------------------------

% (C1) Demand satisfaction:
%    For each customer j, the sum of shipments from all facilities must equal CustomerDemand[j].
constraint
  forall(j in 1..NumberOfCustomers) (
    sum(i in 1..NumberOfFacilities)(CustomerAssignment[i,j]) = CustomerDemand[j]
  );

% (C2) Facility capacity:
%    For each facility i, the total shipment cannot exceed its capacity if it is open.
%    If a facility is closed (FacilityOpen[i] = 0), then no shipment can be made from it.
constraint
  forall(i in 1..NumberOfFacilities) (
    sum(j in 1..NumberOfCustomers)(CustomerAssignment[i,j]) <= FacilityCapacity[i] * FacilityOpen[i]
  );


% -----------------------------
% 4) OBJECTIVE FUNCTION
% -----------------------------
% TotalCost = fixed costs for open facilities + transportation cost for all shipments.
constraint
  TotalCost = sum(i in 1..NumberOfFacilities)(FacilityFixedCost[i] * FacilityOpen[i])
            + sum(i in 1..NumberOfFacilities, j in 1..NumberOfCustomers)(
                FacilityToCustomerTransportCost[i,j] * CustomerAssignment[i,j]
              );

solve minimize TotalCost;


% -----------------------------
% 5) OUTPUT
% -----------------------------
output [
    "Facility Open: ", show(FacilityOpen), "\n",
    "Customer Assignment:\n",
    concat([ "  Facility " ++ show(i) ++ ": " ++ show([CustomerAssignment[i,j] | j in 1..NumberOfCustomers]) ++ "\n"
             | i in 1..NumberOfFacilities ]),
    "Total Cost: ", show(TotalCost), "\n"
];
