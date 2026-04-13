include "globals.mzn";

%-----------------------------
% Data (embedded)
%-----------------------------
int: N = 6;
set of int: T = 1..N;

array[T] of int: volume  = [1500, 2500, 4000, 6000, 9000, 12000];
array[T] of int: demand  = [500, 550, 700, 900, 400, 300];
array[T] of int: varCost = [5, 8, 10, 12, 16, 18];

int: setupCost = 1200;

int: totalDemand = sum(t in T)(demand[t]);
int: maxProd = totalDemand;

%-----------------------------
% Decision variables
%-----------------------------
array[T] of var 0..maxProd: prod;
array[T] of var bool: active;

% ship[i,j] = units of type i used to satisfy demand of type j
% Only i>=j allowed; for i<j it is fixed to 0 to reduce search.
array[T, T] of var 0..maxProd: ship;

%-----------------------------
% Constraints
%-----------------------------

% Enforce substitution rule by forbidding smaller types to serve larger-demand types
constraint forall(i in T, j in T where i < j)(ship[i,j] = 0);

% Meet each demand exactly using types with volume >= that demand type
constraint forall(j in T)(
  sum(i in T)(ship[i,j]) = demand[j]
);

% Production balance: shipped units of each type cannot exceed produced units
constraint forall(i in T)(
  sum(j in T)(ship[i,j]) <= prod[i]
);

% Link production to activation (tight big-M)
constraint forall(i in T)(
  prod[i] <= maxProd * bool2int(active[i])
);
constraint forall(i in T)(
  prod[i] >= bool2int(active[i])
);

%-----------------------------
% Objective
%-----------------------------
var int: totalCost =
  sum(i in T)(varCost[i] * prod[i]) +
  setupCost * sum(i in T)(bool2int(active[i]));

solve :: int_search([prod[i] | i in T] ++ [ship[i,j] | i in T, j in T where i >= j],
                    first_fail, indomain_min, complete)
minimize totalCost;

%-----------------------------
% Output
%-----------------------------
output [
  "totalCost = ", show(totalCost), "\n",
  "prod = ", show(prod), "\n",
  "active = ", show(active), "\n",
  "ship (i>=j):\n"
] ++
[
  if i>=j then
    "ship[" ++ show(i) ++ "," ++ show(j) ++ "]=" ++ show(ship[i,j]) ++ "\n"
  else
    ""
  endif
  | i in T, j in T
];