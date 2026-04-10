% Parameters
int: K;
int: S;

array[1..K, 1..S] of int: Time;
array[1..K] of int: Profit;
array[1..S] of int: Capacity;

% Variables
int: maxCap = max(Capacity);
int: minPosTime = min([Time[k,s] | k in 1..K, s in 1..S where Time[k,s] > 0] ++ [1]);
int: maxUnits = maxCap div minPosTime;

array[1..K] of var 0..maxUnits: Qty;

% Constraints
constraint
  forall(s in 1..S) (
    sum(k in 1..K) (Time[k,s] * Qty[k]) <= Capacity[s]
  );

% Objective
solve maximize sum(k in 1..K) (Profit[k] * Qty[k]);