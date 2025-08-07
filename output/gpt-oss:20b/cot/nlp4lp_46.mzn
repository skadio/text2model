% Parameters
int: N;
int: M;
array[1..N] of int: Available;
array[1..N, 1..M] of int: Requirements;
array[1..M] of int: Prices;
array[1..M] of int: Costs;
array[1..M] of int: Demands;

% Variables
array[1..M] of var int: x;

% Constraints
constraint
  % Production quantity bounds
  forall(j in 1..M) (
    x[j] >= 0 /\ x[j] <= Demands[j]
  ) /\
  % Raw material availability
  forall(i in 1..N) (
    sum(j in 1..M) Requirements[i,j] * x[j] <= Available[i]
  );

% Objective
solve maximize
  sum(j in 1..M) (Prices[j] - Costs[j]) * x[j];