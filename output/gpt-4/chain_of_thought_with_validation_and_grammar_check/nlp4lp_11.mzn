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
array[1..K] of var 0..max(Capacity): Production;
array[1..K] of var 0..max(Stock): StockNextYear;
array[1..K] of var 0..max(Capacity): CapacityNextYear;
array[1..K] of var 0..max(Demand): Consumption;
array[1..K] of var 0..sum(i in 1..K)(Capacity[i]): TotalManpower;

% Constraints
constraint forall(i in 1..K)(
  Production[i] <= Capacity[i]
);
constraint forall(i in 1..K)(
  StockNextYear[i] = Stock[i] + Production[i] - Consumption[i]
);
constraint forall(i in 1..K)(
  CapacityNextYear[i] = sum(j in 1..K)(InputOne[i,j]*Production[j]) + sum(j in 1..K)(InputTwo[i,j]*Production[j])
);
constraint forall(i in 1..K)(
  Consumption[i] >= Demand[i]
);
constraint forall(i in 1..K)(
  TotalManpower[i] = ManpowerOne[i]*Production[i] + ManpowerTwo[i]*CapacityNextYear[i]
);

% Objective
solve maximize sum(i in 1..K)(TotalManpower[i]);