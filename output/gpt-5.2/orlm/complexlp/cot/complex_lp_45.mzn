% Parameters (with values embedded)
int: N = 4;
set of int: CLINICS = 1..N;

array[CLINICS] of int: initial_stock = [330, 294, 474, 86];
array[CLINICS] of int: required_stock = [476, 92, 385, 203];

% cost[i,j] = unit cost to ship from clinic i to clinic j (0 on diagonal, shipments disallowed/unused there)
array[CLINICS, CLINICS] of int: cost =
[
  [0,  2, 12, 19],
  [28, 0,  9, 10],
  [23, 46, 0,  7],
  [19, 16, 23, 0]
];

% Variables
array[CLINICS, CLINICS] of var 0..max(initial_stock): ship; % ship[i,j] units shipped from i to j

% Constraints
constraint forall(i in CLINICS) (ship[i,i] = 0);

% Flow balance at each clinic: initial - outgoing + incoming = required
constraint
  forall(k in CLINICS) (
    initial_stock[k]
    - sum(j in CLINICS)(ship[k,j])
    + sum(i in CLINICS)(ship[i,k])
    = required_stock[k]
  );

% Objective
var int: total_cost = sum(i in CLINICS, j in CLINICS)(cost[i,j] * ship[i,j]);

solve minimize total_cost;