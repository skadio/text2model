% Parameters
int: K;
array[1..K, 1..K] of float: InputOne;
array[1..K] of float: ManpowerOne;
array[1..K, 1..K] of float: InputTwo;
array[1..K] of float: ManpowerTwo;
array[1..K] of float: Stock;
array[1..K] of float: Capacity;
float: ManpowerLimit;
array[1..K] of float: Demand;

% Variables
array[1..K, 1..K] of var 0.0..ManpowerLimit: ProductionOne;
array[1..K, 1..K] of var 0.0..ManpowerLimit: ProductionTwo;
array[1..K] of var 0.0..ManpowerLimit: TotalProduction;

% Constraints
constraint forall(i in 1..K)(TotalProduction[i] = sum(j in 1..K)(ProductionOne[i,j] + ProductionTwo[i,j]));
constraint forall(i in 1..K)(sum(j in 1..K)(ProductionOne[i,j]*InputOne[i,j] + ProductionTwo[i,j]*InputTwo[i,j]) <= Stock[i]);
constraint forall(i in 1..K)(sum(j in 1..K)(ProductionOne[i,j]*ManpowerOne[i] + ProductionTwo[i,j]*ManpowerTwo[i]) <= ManpowerLimit);
constraint forall(i in 1..K)(TotalProduction[i] >= Demand[i]);

% Objective
solve maximize sum(i in 1..K)(TotalProduction[i]);