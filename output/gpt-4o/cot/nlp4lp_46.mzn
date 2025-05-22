% Parameters
int: N;
int: M;
array[1..N] of int: Available;
array[1..N, 1..M] of int: Requirements;
array[1..M] of int: Prices;
array[1..M] of int: Costs;
array[1..M] of int: Demands;

int: maxDemand = max(Demands);

% Variables
array[1..M] of var 0..maxDemand: Produce;

% Constraints
constraint
  forall(i in 1..N)(
    sum(j in 1..M)(Requirements[i, j] * Produce[j]) <= Available[i]
  );

constraint
  forall(j in 1..M)(
    Produce[j] <= Demands[j]
  );

% Objective
solve maximize sum(j in 1..M)((Prices[j] - Costs[j]) * Produce[j]);