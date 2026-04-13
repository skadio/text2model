% Parameters
int: N = 6;
set of int: CLINICS = 1..N;

array[CLINICS] of int: supply = [467, 121, 109, 131, 500, 10];
array[CLINICS] of int: demand = [261, 209, 135, 146, 488, 30];

array[CLINICS, CLINICS] of int: cost =
  [|  0, 43,  8, 15, 37,  9
   |  9,  0, 50, 37, 50, 29
   |  3, 37,  0,  7, 18, 27
   | 15,  3,  3,  0,  2, 48
   | 34, 18, 44,  2,  0, 27
   | 36, 49, 29, 12, 33,  0 |];

int: total_supply = sum(i in CLINICS)(supply[i]);
int: total_demand = sum(i in CLINICS)(demand[i]);
int: total_move_ub = sum(i in CLINICS)(max(0, supply[i] - demand[i]));

% Variables
array[CLINICS, CLINICS] of var 0..total_move_ub: x; % units shipped from i to j
var 0..(total_move_ub * max(i,j in CLINICS)(cost[i,j])): total_cost;

% Constraints
constraint total_supply = total_demand;

constraint forall(i in CLINICS)(x[i,i] = 0);

constraint forall(i in CLINICS)(
  supply[i] - sum(j in CLINICS)(x[i,j]) + sum(j in CLINICS)(x[j,i]) = demand[i]
);

constraint total_cost = sum(i in CLINICS, j in CLINICS)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;