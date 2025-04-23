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
array[1..K] of var 0..Capacity[i]: Production;
array[1..K] of var 0..Stock[i]: StockLevel;
array[1..K] of var 0..ManpowerLimit: ManpowerUsed;

% Constraints
constraint forall(i in 1..K)(Production[i] <= Capacity[i]);
constraint forall(i in 1..K)(StockLevel[i] >= 0);
constraint forall(i in 1..K)(ManpowerUsed[i] <= ManpowerLimit);
constraint forall(i in 1..K, j in 1..K)(Production[i] >= InputOne[i,j] + InputTwo[i,j]);
constraint forall(i in 1..K)(ManpowerUsed[i] >= ManpowerOne[i] + ManpowerTwo[i]);
constraint forall(i in 1..K)(StockLevel[i] = Stock[i] + sum(j in 1..K)(Production[j]) - sum(j in 1..K)(InputOne[i,j] + InputTwo[i,j]));

% Objective
solve maximize sum(i in 1..K)(Production[i]);