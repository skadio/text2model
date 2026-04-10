% Parameters
int: N = 4;
set of int: CLINICS = 1..N;

array[CLINICS] of int: stock = [330, 294, 474, 86];
array[CLINICS] of int: need  = [476, 92, 385, 203];

array[CLINICS, CLINICS] of int: cost = 
  [| 0,  2, 12, 19
   | 28, 0,  9, 10
   | 23, 46, 0,  7
   | 19, 16, 23, 0 |];

array[CLINICS] of int: supply = [max(0, stock[i] - need[i]) | i in CLINICS];
array[CLINICS] of int: demand = [max(0, need[i] - stock[i]) | i in CLINICS];

int: TOTAL_SUPPLY = sum(i in CLINICS)(supply[i]);
int: TOTAL_DEMAND = sum(i in CLINICS)(demand[i]);

% Variables
array[CLINICS, CLINICS] of var 0..TOTAL_SUPPLY: x;
var 0..(TOTAL_SUPPLY * max(i,j in CLINICS)(cost[i,j])): total_cost;

% Constraints
constraint
  forall(i in CLINICS)(x[i,i] = 0);

constraint
  forall(i in CLINICS)(
    sum(j in CLINICS)(x[i,j]) <= supply[i]
  );

constraint
  forall(j in CLINICS)(
    sum(i in CLINICS)(x[i,j]) = demand[j]
  );

constraint
  TOTAL_SUPPLY = TOTAL_DEMAND;

constraint
  total_cost = sum(i in CLINICS, j in CLINICS)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;