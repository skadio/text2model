% Parameters
int: NumParts;
int: NumMachines;

set of int: K = 1..NumParts;
set of int: S = 1..NumMachines;

array[K, S] of int: Time;
array[K] of int: Profit;
array[S] of int: Capacity;

% Variables
int: max_units = max(k in K)(
  min(s in S where Time[k,s] > 0) (Capacity[s] div Time[k,s])
);

array[K] of var 0..max_units: Make;

% Constraints
constraint
  forall(s in S) (
    sum(k in K) (Time[k,s] * Make[k]) <= Capacity[s]
  );

% Objective
solve maximize sum(k in K) (Profit[k] * Make[k]);