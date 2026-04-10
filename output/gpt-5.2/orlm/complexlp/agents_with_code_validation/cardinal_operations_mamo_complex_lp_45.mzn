% Parameters
int: nClinics = 4;                         % Number of clinics
set of int: CLINICS = 1..nClinics;         % Clinic index set

array[CLINICS] of int: initialStock =      % Initial stock at each clinic
  [330, 294, 474, 86];

array[CLINICS] of int: requiredStock =     % Required stock at each clinic
  [476, 92, 385, 203];

array[CLINICS, CLINICS] of int: cost =     % Transportation cost i -> j (0 on diagonal)
  [|  0,  2, 12, 19
   | 28,  0,  9, 10
   | 23, 46,  0,  7
   | 19, 16, 23,  0 |];

% Derived parameters: per-clinic surplus/deficit relative to requirements
array[CLINICS] of int: surplus =
  [ max(0, initialStock[i] - requiredStock[i]) | i in CLINICS ];

array[CLINICS] of int: deficit =
  [ max(0, requiredStock[j] - initialStock[j]) | j in CLINICS ];


% Variables
array[CLINICS, CLINICS] of var 0..max(initialStock): ship;  % Units shipped i -> j
var int: totalCost;                                          % Total transportation cost


% Constraints
% Flow balance: ensure each clinic ends with exactly its required stock
constraint forall(k in CLINICS) (
  initialStock[k]
  + sum(i in CLINICS)(ship[i,k])          % total received by k
  - sum(j in CLINICS)(ship[k,j])          % total sent from k
  = requiredStock[k]
);

% Outgoing shipments limited by available surplus at each origin clinic
constraint forall(i in CLINICS) (
  sum(j in CLINICS)(ship[i,j]) <= surplus[i]
);

% Incoming shipments limited by deficit at each destination clinic
constraint forall(j in CLINICS) (
  sum(i in CLINICS)(ship[i,j]) <= deficit[j]
);

% No self-shipment
constraint forall(i in CLINICS) (
  ship[i,i] = 0
);

% Total transportation cost definition (linear)
constraint totalCost =
  sum(i, j in CLINICS)(cost[i,j] * ship[i,j]);


% Objective
solve minimize totalCost;