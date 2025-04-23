% Parameters
int: K;
array[1..K, 1..K] of float: InputOne;
array[1..K] of float: ManpowerOne;
array[1..K, 1..K] of float: InputTwo;
array[1..K] of float: ManpowerTwo;
array[1..K] of int: Stock;
array[1..K] of int: Capacity;
float: ManpowerLimit;
array[1..K] of float: Demand;

% Variables
array[1..K, 1..K] of var 0..Capacity[i]: Production;
array[1..K, 1..K] of var 0..Capacity[i]: Increase;

% Constraints
constraint forall(i in 1..K)(sum(j in 1..K)(InputOne[i,j]*Production[i,j] + InputTwo[i,j]*Increase[i,j]) <= Capacity[i]);
constraint forall(i in 1..K)(sum(j in 1..K)(ManpowerOne[i]*Production[i,j] + ManpowerTwo[i]*Increase[i,j]) <= ManpowerLimit);
constraint forall(i in 1..K)(sum(j in 1..K)(Production[i,j]) >= Demand[i]);
constraint forall(i in 1..K)(sum(j in 1..K)(Increase[i,j]) <= Stock[i]);

% Objective
solve maximize sum(i in 1..K)(sum(j in 1..K)(Production[i,j] + Increase[i,j]));