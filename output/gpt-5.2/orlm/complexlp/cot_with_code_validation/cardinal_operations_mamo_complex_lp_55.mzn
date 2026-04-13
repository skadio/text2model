% Parameters
int: N = 6;
set of int: CLINICS = 1..N;

array[CLINICS] of int: supply = [467, 121, 109, 131, 500, 10];
array[CLINICS] of int: demand = [261, 209, 135, 146, 488, 30];

array[CLINICS, CLINICS] of int: cost =
[| 0, 43,  8, 15, 37,  9
 | 9,  0, 50, 37, 50, 29
 | 3, 37,  0,  7, 18, 27
 |15,  3,  3,  0,  2, 48
 |34, 18, 44,  2,  0, 27
 |36, 49, 29, 12, 33,  0 |];

int: total_supply = sum(i in CLINICS)(supply[i]);
int: total_demand = sum(i in CLINICS)(demand[i]);

% Variables
int: max_supply = max(i in CLINICS)(supply[i]);

array[CLINICS, CLINICS] of var 0..max_supply: x;

var 0..(max(i,j in CLINICS where i != j)(cost[i,j]) * total_supply): total_cost;

% Constraints
constraint total_supply = total_demand;

constraint forall(i,j in CLINICS where i = j)(x[i,j] = 0);

constraint forall(i in CLINICS)(
  sum(j in CLINICS)(x[i,j]) <= supply[i]
);

constraint forall(k in CLINICS)(
  supply[k] - sum(j in CLINICS)(x[k,j]) + sum(i in CLINICS)(x[i,k]) = demand[k]
);

constraint total_cost = sum(i,j in CLINICS)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;