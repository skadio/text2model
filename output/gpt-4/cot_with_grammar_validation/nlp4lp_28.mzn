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
array[1..K] of var 0..max(Capacity): Production;
array[1..K] of var 0..ManpowerLimit: Manpower;

% Constraints
constraint forall(i in 1..K)(sum(j in 1..K)(InputOne[i,j]*Production[j]) + ManpowerOne[i]*Manpower[i] <= Capacity[i]);
constraint forall(i in 1..K)(sum(j in 1..K)(InputTwo[i,j]*Production[j]) + ManpowerTwo[i]*Manpower[i] <= Capacity[i]);
constraint forall(i in 1..K)(Manpower[i] <= ManpowerLimit);
constraint forall(i in 1..K)(Production[i] <= Stock[i] + sum(j in 1..K)(InputOne[i,j]*Production[j]) + sum(j in 1..K)(InputTwo[i,j]*Production[j]));

% Objective
solve maximize sum(i in 1..K)(Production[i]);