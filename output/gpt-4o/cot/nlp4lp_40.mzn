% Parameters
int: K;
int: S;

array[1..K, 1..S] of int: Time;
array[1..K] of int: Profit;
array[1..S] of int: Capacity;

% Derived parameters
int: MaxCap = max(s in 1..S)(Capacity[s]);

% Variables
array[1..K] of var 0..MaxCap: qty;   % qty[k] = number of units of part k to produce

% Constraints
constraint
  forall(s in 1..S)(
    sum(k in 1..K)(Time[k,s] * qty[k]) <= Capacity[s]
  );

% Objective
solve maximize sum(k in 1..K)(Profit[k] * qty[k]);