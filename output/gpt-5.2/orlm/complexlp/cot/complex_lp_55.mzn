% Parameters (with values embedded)
int: N = 6;
set of int: CLINICS = 1..N;

array[CLINICS] of int: supply = [467, 121, 109, 131, 500, 10];
array[CLINICS] of int: demand = [261, 209, 135, 146, 488, 30];

% cost[i,j] = cost per unit shipped from clinic i to clinic j
array[CLINICS, CLINICS] of int: cost =
[|  0, 43,  8, 15, 37,  9
 |  9,  0, 50, 37, 50, 29
 |  3, 37,  0,  7, 18, 27
 | 15,  3,  3,  0,  2, 48
 | 34, 18, 44,  2,  0, 27
 | 36, 49, 29, 12, 33,  0 |];

int: total_supply = sum(i in CLINICS)(supply[i]);  % 1338
int: total_demand = sum(i in CLINICS)(demand[i]);  % 1269
int: total_excess = total_supply - total_demand;   % 69

% Variables
% x[i,j] = units shipped from clinic i to clinic j
array[CLINICS, CLINICS] of var 0..max(supply): x;

% Constraints
% No self-shipping
constraint forall(i in CLINICS)(x[i,i] = 0);

% Flow balance: initial supply + inflow - outflow = final stock (must equal demand plus possible leftover)
% Since total_supply > total_demand, allow leftover only at clinic 1, set others exact.
constraint
  supply[1]
  + sum(i in CLINICS)(x[i,1])
  - sum(j in CLINICS)(x[1,j])
  = demand[1] + total_excess;

constraint forall(k in 2..N)(
  supply[k]
  + sum(i in CLINICS)(x[i,k])
  - sum(j in CLINICS)(x[k,j])
  = demand[k]
);

% Optional: cannot ship out more than available at origin (redundant but strengthens)
constraint forall(i in CLINICS)(
  sum(j in CLINICS)(x[i,j]) <= supply[i] + sum(k in CLINICS)(x[k,i])
);

% Objective
var int: total_cost = sum(i in CLINICS, j in CLINICS)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "Minimum total transportation cost = ", show(total_cost), "\n",
  "Shipment matrix x (from i to j):\n"
] ++
[
  if j = 1 then "" else "" endif ++
  show(x[i,j]) ++ (if j = N then "\n" else " " endif)
  | i in CLINICS, j in CLINICS
];