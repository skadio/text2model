% Parameters
int: NumProducts;
int: NumMachines;

set of int: K = 1..NumProducts;
set of int: S = 1..NumMachines;

array[K, S] of int: ProduceTime;
array[S] of int: AvailableTime;
array[K] of int: Profit;

% Variables
array[K] of var int: Qty;
var int: TotalProfit;

% Constraints
constraint forall(k in K)(Qty[k] >= 0);

constraint forall(s in S)(
  sum(k in K)(ProduceTime[k,s] * Qty[k]) <= AvailableTime[s]
);

constraint TotalProfit = sum(k in K)(Profit[k] * Qty[k]);

% Objective
solve maximize TotalProfit;