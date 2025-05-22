% Parameters
int: K;
array[1..K, 1..K] of float: InputOne;
array[1..K] of float: ManpowerOne;
array[1..K, 1..K] of float: InputTwo;
array[1..K] of float: ManpowerTwo;
array[1..K] of int: Stock;
array[1..K] of int: Capacity;
float: ManpowerLimit;

% Variables
array[1..K, 1..K] of var 0.0..ManpowerLimit: ProductionOne;
array[1..K, 1..K] of var 0.0..ManpowerLimit: ProductionTwo;
array[1..K] of var 0..sum(Capacity): TotalProduction;

% Constraints
constraint forall(i in 1..K)(TotalProduction[i] = sum(j in 1..K)(ProductionOne[i,j] + ProductionTwo[i,j]));

constraint forall(i in 1..K, j in 1..K)(ProductionOne[i,j] <= InputOne[i,j] * Capacity[j]);
constraint forall(i in 1..K, j in 1..K)(ProductionTwo[i,j] <= InputTwo[i,j] * Capacity[j]);

constraint forall(i in 1..K)(sum(j in 1..K)(ProductionOne[i,j] * ManpowerOne[j] + ProductionTwo[i,j] * ManpowerTwo[j]) <= ManpowerLimit);

constraint forall(i in 1..K)(TotalProduction[i] <= Capacity[i] + Stock[i]);

% Objective
var int: LastTwoYearsProduction;
constraint LastTwoYearsProduction = TotalProduction[K] + (if K > 1 then TotalProduction[K-1] else 0 endif);
solve maximize LastTwoYearsProduction;