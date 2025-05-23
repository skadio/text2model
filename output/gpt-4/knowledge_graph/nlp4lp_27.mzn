include "globals.mzn";

% Parameters
int: K; % Total number of years in the planning horizon
array[1..K, 1..K] of float: InputOne; % Input one coefficients matrix
array[1..K] of float: ManpowerOne; % Manpower coefficients for input one
array[1..K, 1..K] of float: InputTwo; % Input two coefficients matrix
array[1..K] of float: ManpowerTwo; % Manpower coefficients for input two
array[1..K] of int: Stock; % Initial stock level for each of the productive units
array[1..K] of int: Capacity; % Productive capacity for each productive unit
float: ManpowerLimit; % Company-wide manpower limit
array[1..K] of float: Demand; % Demand for each of the productive units at the end of the planning horizon

% Variables
array[1..K, 1..K] of var 0..Capacity[i]: ProductionOne; % Production of input one
array[1..K, 1..K] of var 0..Capacity[i]: ProductionTwo; % Production of input two

% Constraints
constraint forall(i in 1..K) (
  sum(j in 1..K) (ProductionOne[i,j]*ManpowerOne[i] + ProductionTwo[i,j]*ManpowerTwo[i]) <= ManpowerLimit
);

constraint forall(i in 1..K) (
  sum(j in 1..K) (ProductionOne[i,j]*InputOne[i,j] + ProductionTwo[i,j]*InputTwo[i,j]) <= Stock[i]
);

constraint forall(i in 1..K) (
  sum(j in 1..K) (ProductionOne[i,j] + ProductionTwo[i,j]) >= Demand[i]
);

% Objective
var float: TotalCapacity = sum(i in 1..K) (sum(j in 1..K) (ProductionOne[i,j] + ProductionTwo[i,j]));

solve maximize TotalCapacity;

output [ "Total Capacity: \(TotalCapacity)\n" ];