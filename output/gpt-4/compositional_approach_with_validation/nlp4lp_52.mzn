% Parameters
int: M; % Number of machines
int: P; % Number of parts to be produced
array[1..M, 1..P] of int: TimeRequired; % Time required to produce a batch of part p on machine m
array[1..M] of int: MachineCosts; % Cost associated with running machine m
array[1..M] of int: Availability; % Availability of machine m per month
array[1..P] of int: Prices; % Selling price of a batch of part p
array[1..P] of int: MinBatches; % Minimum number of batches of part p that should be produced

% Variables
array[1..P] of var 0..100: Batches; % Number of batches of each part to be produced

% Constraints

% Constraint 1: The number of batches produced for each part should be greater than or equal to the minimum number of batches required
constraint forall(p in 1..P) (
  Batches[p] >= MinBatches[p]
);

% Constraint 2: The total time spent on each machine should not exceed its availability
constraint forall(m in 1..M) (
  sum(p in 1..P) (TimeRequired[m,p] * Batches[p]) <= Availability[m]
);

% Constraint 3: The total time spent on machine M and M-1 should not exceed their combined availability
constraint sum(p in 1..P) (TimeRequired[M,p] * Batches[p] + TimeRequired[M-1,p] * Batches[p]) <= Availability[M] + Availability[M-1];

% Constraint 4: The cost of running each machine should not exceed the revenue generated from the parts produced on it
constraint forall(m in 1..M) (
  MachineCosts[m] * sum(p in 1..P) (TimeRequired[m,p] * Batches[p]) <= sum(p in 1..P) (Prices[p] * Batches[p])
);

% Objective
solve maximize sum(p in 1..P) (Prices[p] * Batches[p]) - sum(m in 1..M) (MachineCosts[m] * sum(p in 1..P) (TimeRequired[m,p] * Batches[p]));