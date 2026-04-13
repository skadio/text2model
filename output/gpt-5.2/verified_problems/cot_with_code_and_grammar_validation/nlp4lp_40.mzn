% Parameters
int: K;
int: S;

array[1..K, 1..S] of int: Time;
array[1..K] of int: Profit;
array[1..S] of int: Capacity;

% Variables
array[1..K] of var 0..max(Capacity): Qty;

var int: TotalProfit;

% Constraints
constraint
  forall(s in 1..S) (
    sum(k in 1..K) (Time[k,s] * Qty[k]) <= Capacity[s]
  );

constraint
  TotalProfit = sum(k in 1..K) (Profit[k] * Qty[k]);

% Objective
solve maximize TotalProfit;