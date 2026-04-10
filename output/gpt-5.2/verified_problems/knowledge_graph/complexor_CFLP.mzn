include "globals.mzn";

int: NumberOfFacilities;
int: NumberOfCustomers;

set of int: F = 1..NumberOfFacilities;
set of int: C = 1..NumberOfCustomers;

array[F] of int: FacilityFixedCost;
array[F, C] of int: FacilityToCustomerTransportCost;
array[F] of int: FacilityCapacity;
array[C] of int: CustomerDemand;

array[F] of var bool: Open;
array[F, C] of var int: Ship;

constraint
  forall(i in F, j in C) (
    Ship[i,j] >= 0
  );

% Demand satisfaction
constraint
  forall(j in C) (
    sum(i in F)(Ship[i,j]) = CustomerDemand[j]
  );

% Capacity and opening link
constraint
  forall(i in F) (
    sum(j in C)(Ship[i,j]) <= FacilityCapacity[i] * bool2int(Open[i])
  );

var int: TotalFixedCost =
  sum(i in F)(FacilityFixedCost[i] * bool2int(Open[i]));

var int: TotalTransportCost =
  sum(i in F, j in C)(FacilityToCustomerTransportCost[i,j] * Ship[i,j]);

var int: TotalCost = TotalFixedCost + TotalTransportCost;

solve minimize TotalCost;

output [
  "TotalCost=", show(TotalCost), "\n",
  "TotalFixedCost=", show(TotalFixedCost), "\n",
  "TotalTransportCost=", show(TotalTransportCost), "\n",
  "Open=", show(Open), "\n",
  "Ship=\n"
] ++
[
  if j = 1 then "" else "" endif ++
  concat([ show(Ship[i,j]) ++ if i = NumberOfFacilities then "\n" else " " endif | i in F ])
  | j in C
];