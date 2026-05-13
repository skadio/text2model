% Parameters
int: K;
int: S;
array[1..K, 1..S] of int: Time;
array[1..K] of int: Profit;
array[1..S] of int: Capacity;

% Variables
array[1..K] of var 0..maxint: Qty;

% Constraints
constraint
  forall(s in 1..S) (
    sum(k in 1..K) (Qty[k] * Time[k,s]) <= Capacity[s]
  );

% Objective
solve maximize
  sum(k in 1..K) (Qty[k] * Profit[k]);