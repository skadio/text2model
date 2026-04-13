% Parameters
int: nHospitals = 4;                         % Number of hospitals
set of int: H = 1..nHospitals;               % Hospital index set

array[H] of int: supply = [480, 492, 74, 317];  % Initial supplies at each hospital
array[H] of int: demand = [61, 313, 93, 199];   % Required supplies at each hospital

% Transfer cost per unit from hospital i to hospital j (i != j); diagonal set to 0
array[H, H] of int: cost =
  [| 0,  8, 42, 27
   |17,  0, 13, 30
   | 4, 14,  0, 16
   |33,  9, 42,  0 |];

% Variables
% x[i,j] = units transferred from hospital i to hospital j
array[H, H] of var int: x;

% Constraints
% Variable bounds: nonnegative, and cannot exceed origin supply (simple safe upper bound)
constraint forall(i in H, j in H) (
  x[i,j] >= 0 /\
  x[i,j] <= supply[i]
);

% No self-transfer
constraint forall(i in H) ( x[i,i] = 0 );

% Flow conservation: each hospital's final stock (initial + inflow - outflow) meets its demand
constraint
  forall(h in H) (
    supply[h]
    + sum(i in H where i != h)(x[i,h])          % inflow to h
    - sum(j in H where j != h)(x[h,j])          % outflow from h
    >= demand[h]
  );

% Global feasibility: total available supply must cover total demand (sanity check)
constraint
  sum(h in H)(supply[h]) >= sum(h in H)(demand[h]);

% Do not ship more than the surplus available at each origin hospital
constraint
  forall(i in H) (
    sum(j in H where j != i)(x[i,j]) <= max(0, supply[i] - demand[i])
  );

% Objective
solve minimize sum(i in H, j in H)(cost[i,j] * x[i,j]);