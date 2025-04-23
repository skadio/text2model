include "globals.mzn";

% Parameters
int: K; % Total number of years in the planning horizon
array[1..K, 1..K] of float: InputOne; % Input one coefficients matrix
array[1..K] of float: ManpowerOne; % Manpower coefficients for input one
array[1..K, 1..K] of float: InputTwo; % Input two coefficients matrix
array[1..K] of float: ManpowerTwo; % Manpower coefficients for input two
array[1..K] of float: Stock; % Initial stock level for each of the productive units
array[1..K] of float: Capacity; % Productive capacity for each productive unit
float: ManpowerLimit; % Company-wide manpower limit
array[1..K] of float: Demand; % Demand for each of the productive units at the end of the planning horizon

% Decision variables
array[1..K, 1..K] of var 0..ManpowerLimit: ProductionOne; % Production of input one
array[1..K, 1..K] of var 0..ManpowerLimit: ProductionTwo; % Production of input two

% Constraints
constraint forall(i in 1..K) (
  sum(j in 1..K) (InputOne[i,j]*ProductionOne[i,j] + InputTwo[i,j]*ProductionTwo[i,j]) <= Capacity[i]
);

constraint forall(i in 1..K) (
  sum(j in 1..K) (ManpowerOne[i]*ProductionOne[i,j] + ManpowerTwo[i]*ProductionTwo[i,j]) <= ManpowerLimit
);

constraint forall(i in 1..K) (
  sum(j in 1..K) (ProductionOne[i,j] + ProductionTwo[i,j]) >= Demand[i]
);

% Objective
var float: TotalCapacity = sum(i in 1..K) (Capacity[i] + sum(j in 1..K) (ProductionOne[i,j] + ProductionTwo[i,j]));

solve maximize TotalCapacity;

% Output
output [ "Total Capacity: " ++ show(TotalCapacity) ++ "\n" ] ++
[ if fix(ProductionOne[i,j]) > 0 then "Produce " ++ show(ProductionOne[i,j]) ++ " units of input one in industry " ++ show(i) ++ " in year " ++ show(j) ++ "\n" else "" endif | i in 1..K, j in 1..K ] ++
[ if fix(ProductionTwo[i,j]) > 0 then "Produce " ++ show(ProductionTwo[i,j]) ++ " units of input two in industry " ++ show(i) ++ " in year " ++ show(j) ++ "\n" else "" endif | i in 1..K, j in 1..K ];