% Parameters
int: K;
array[1..K] of float: ManpowerOne;
array[1..K] of float: ManpowerTwo;
array[1..K] of int: Stock;
array[1..K] of int: Capacity;
array[1..K] of float: Demand;
array[1..K, 1..K] of float: InputOne;
array[1..K, 1..K] of float: InputTwo;

% Variables
array[1..K] of var 0..Capacity[i]: Production;
array[1..K] of var 0..Stock[i]: StockUsed;
array[1..K] of var 0..Stock[i]: StockLeft;
array[1..K] of var 0..Capacity[i]: CapacityIncrease;

% Constraints
constraint forall(i in 1..K)(
  Production[i] <= Capacity[i] + CapacityIncrease[i]
);
constraint forall(i in 1..K)(
  StockUsed[i] <= Stock[i]
);
constraint forall(i in 1..K)(
  StockLeft[i] = Stock[i] - StockUsed[i]
);
constraint forall(i in 1..K)(
  Production[i] + StockLeft[i] >= Demand[i]
);
constraint forall(i in 1..K, j in 1..K)(
  Production[i] >= InputOne[i,j]*Production[j] + InputTwo[i,j]*CapacityIncrease[j]
);

% Objective
var float: TotalManpower = sum(i in 1..K)(ManpowerOne[i]*Production[i] + ManpowerTwo[i]*CapacityIncrease[i]);
solve maximize TotalManpower;