% Medical supplies redistribution / transportation problem
% Minimize total transportation cost while meeting exact demand at each clinic.

int: n = 6;
set of int: CLINICS = 1..n;

array[CLINICS] of int: supply = [467, 121, 109, 131, 500, 10];
array[CLINICS] of int: demand = [261, 209, 135, 146, 488, 30];

% cost[i,j] = cost per unit shipped from i to j (i != j). Diagonal is 0 (no shipping to self).
array[CLINICS, CLINICS] of int: cost =
  array2d(CLINICS, CLINICS,
  [  0, 43,  8, 15, 37,  9,
     9,  0, 50, 37, 50, 29,
     3, 37,  0,  7, 18, 27,
    15,  3,  3,  0,  2, 48,
    34, 18, 44,  2,  0, 27,
    36, 49, 29, 12, 33,  0 ]);

% Decision variables: flow[i,j] = units shipped from i to j
array[CLINICS, CLINICS] of var 0..max(supply): flow;

% No self-shipment
constraint forall(i in CLINICS)(flow[i,i] = 0);

% Flow conservation per clinic:
% final = supply - outgoing + incoming = demand
constraint forall(k in CLINICS)(
    supply[k]
  - sum(j in CLINICS)(flow[k,j])
  + sum(i in CLINICS)(flow[i,k])
  = demand[k]
);

% Objective: minimize total transportation cost
var int: total_cost = sum(i in CLINICS, j in CLINICS)(cost[i,j] * flow[i,j]);

solve minimize total_cost;

output [
  "Minimum total cost = ", show(total_cost), "\n",
  "Flow matrix (rows=from, cols=to):\n",
  concat([ concat([ if j=1 then "" else " " endif ++ show(flow[i,j]) | j in CLINICS ]) ++ "\n"
          | i in CLINICS ])
];