include "globals.mzn";

% Parameters
int: K;
array[1..K] of float: ManpowerOne;
array[1..K] of float: ManpowerTwo;
array[1..K] of int: Stock;
array[1..K] of int: Capacity;
array[1..K] of float: Demand;
array[1..K, 1..K] of float: InputOne;
array[1..K, 1..K] of float: InputTwo;

% Decision Variables
array[1..K] of var 0..Capacity[i]: Production;
array[1..K] of var 0..Stock[i]: StockUsed;
array[1..K] of var 0..Stock[i]: StockLeft;

% Constraints
constraint forall(i in 1..K)(
  Production[i] <= Capacity[i] % Production cannot exceed capacity
);

constraint forall(i in 1..K)(
  StockUsed[i] <= Stock[i] % Cannot use more stock than available
);

constraint forall(i in 1..K)(
  StockLeft[i] = Stock[i] - StockUsed[i] % Stock left after use
);

constraint forall(i in 1..K)(
  sum(j in 1..K) (InputOne[i,j]*Production[j] + InputTwo[i,j]*StockUsed[j]) >= Demand[i] % Demand must be satisfied
);

% Objective
var float: totalManpower;
constraint totalManpower = sum(i in 1..K) (ManpowerOne[i]*Production[i] + ManpowerTwo[i]*StockUsed[i]);
solve maximize totalManpower;

% Output
output [ "Total Manpower: " ++ show(totalManpower) ++ "\n" ] ++
[ if fix(Production[i]) > 0 then "Year " ++ show(i) ++ ": Produce " ++ show(Production[i]) ++ " units\n" else "" endif | i in 1..K ] ++
[ if fix(StockUsed[i]) > 0 then "Year " ++ show(i) ++ ": Use " ++ show(StockUsed[i]) ++ " units from stock\n" else "" endif | i in 1..K ];