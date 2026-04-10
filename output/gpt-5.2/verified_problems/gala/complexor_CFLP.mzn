include "globals.mzn";

%----------------------------
% Input data (from .dzn)
%----------------------------
int: NumberOfFacilities;
int: NumberOfCustomers;

array[1..NumberOfFacilities] of int: FacilityFixedCost;
array[1..NumberOfFacilities, 1..NumberOfCustomers] of int: FacilityToCustomerTransportCost;
array[1..NumberOfFacilities] of int: FacilityCapacity;
array[1..NumberOfCustomers] of int: CustomerDemand;

%----------------------------
% Sets / indices
%----------------------------
set of int: F = 1..NumberOfFacilities;
set of int: C = 1..NumberOfCustomers;

%----------------------------
% Decision variables
%----------------------------
array[F] of var 0..1: open;  % 1 if facility f is opened
array[F, C] of var 0..max(CustomerDemand): ship; % quantity shipped f -> c

%----------------------------
% Constraints
%----------------------------

% Demand satisfaction: each customer's demand must be met exactly
constraint forall(c in C)(
  sum(f in F)(ship[f,c]) = CustomerDemand[c]
);

% Facility capacity and linking to opening decision
constraint forall(f in F)(
  sum(c in C)(ship[f,c]) <= FacilityCapacity[f] * open[f]
);

% (Optional tightening) total capacity must cover total demand
constraint sum(f in F)(FacilityCapacity[f] * open[f]) >= sum(c in C)(CustomerDemand[c]);

%----------------------------
% Objective: fixed opening costs + transportation costs
%----------------------------
var int: total_cost =
  sum(f in F)(FacilityFixedCost[f] * open[f]) +
  sum(f in F, c in C)(FacilityToCustomerTransportCost[f,c] * ship[f,c]);

solve minimize total_cost;

%----------------------------
% Output
%----------------------------
output [
  "TotalCost = ", show(total_cost), "\n",
  "Open = ", show(open), "\n",
  "Ship =\n",
  concat([ concat([ show(ship[f,c]) ++ if c = NumberOfCustomers then "\n" else " " endif
                  | c in C ])
          | f in F ])
];