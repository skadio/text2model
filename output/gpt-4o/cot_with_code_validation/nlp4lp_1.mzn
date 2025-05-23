% Parameters
int: M;
int: N;
array[1..N] of int: Available;
array[1..M, 1..N] of int: Requirements; % Requirements[j,i] = material i needed for one unit of good j
array[1..M] of int: Prices;

% Derived parameters
int: TotalAvailable = sum(i in 1..N)(Available[i]);

% Decision variables
array[1..M] of var 0..TotalAvailable: Produce;

% Constraints
constraint
  forall(i in 1..N)(
    sum(j in 1..M)(Requirements[j,i] * Produce[j]) <= Available[i]
  );

% Objective
solve maximize sum(j in 1..M)(Prices[j] * Produce[j]);