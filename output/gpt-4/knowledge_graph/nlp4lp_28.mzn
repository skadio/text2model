include "globals.mzn";

% Parameters
int: K; % Total number of years in the planning horizon
array[1..K, 1..K] of float: InputOne; % The production inputs from resource type one to product k in year j
array[1..K] of float: ManpowerOne; % The manpower allocated to resource type one for product k
array[1..K, 1..K] of float: InputTwo; % The production inputs from resource type two to product k in year j
array[1..K] of float: ManpowerTwo; % The manpower allocated to resource type two for product k
array[1..K] of int: Stock; % Stock levels of product k at the start of the planning horizon
array[1..K] of int: Capacity; % Production capacity for product k
float: ManpowerLimit; % The upper limit of manpower

% Variables
array[1..K] of var 0..Capacity[i]: Production; % Production for each year
array[1..K] of var 0..ManpowerLimit: Manpower; % Manpower for each year

% Constraints
constraint forall(i in 1..K)(
  sum(j in 1..K)(InputOne[i,j]*Production[j]) + ManpowerOne[i]*Manpower[i] <= Capacity[i]
);
constraint forall(i in 1..K)(
  sum(j in 1..K)(InputTwo[i,j]*Production[j]) + ManpowerTwo[i]*Manpower[i] <= Capacity[i]
);
constraint forall(i in 1..K)(
  Manpower[i] <= ManpowerLimit
);
constraint forall(i in 1..K)(
  Production[i] <= Stock[i]
);

% Objective
var int: total_production = sum(i in 1..K)(Production[i]);
solve maximize total_production;

% Output
output ["Total production: ", show(total_production), "\n"] ++
["Production: "] ++ [show(Production[i]) | i in 1..K] ++ ["\n"] ++
["Manpower: "] ++ [show(Manpower[i]) | i in 1..K] ++ ["\n"];