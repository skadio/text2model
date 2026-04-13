% Parameters
int: M;
int: N;

array[1..N] of int: Available;
array[1..N, 1..M] of int: Requirements;
array[1..M] of int: Prices;

% Variables
array[1..M] of var 0..max(Available): Produce;
var int: TotalRevenue;

% Constraints
constraint
  forall(j in 1..M) (
    Produce[j] >= 0
  );

constraint
  forall(i in 1..N) (
    sum(j in 1..M) (Requirements[i,j] * Produce[j]) <= Available[i]
  );

constraint
  TotalRevenue = sum(j in 1..M) (Prices[j] * Produce[j]);

% Objective
solve maximize TotalRevenue;