% Parameters
int: P; % Number of parts
int: M; % Number of machines
array[1..M, 1..P] of int: TimeRequired; % Time required to produce one batch of part p on machine m
array[1..M] of int: MachineCosts; % Cost associated with using machine m
array[1..M] of int: Availability; % Availability of machine m per month
array[1..P] of int: Prices; % Selling price of one batch of part p
array[1..P] of int: MinBatches; % Minimum number of batches of part p to be produced

% Variables
array[1..P] of var 0..int: Batches; % Number of batches of each part to be produced

% Constraints

% Constraint 1: The number of batches produced for each part should be greater than or equal to the minimum number of batches required
constraint forall(p in 1..P) (
  Batches[p] >= MinBatches[p]
);

% Constraint 2: The total time spent on each machine should not exceed its availability
constraint forall(m in 1..M) (
  sum(p in 1..P) (TimeRequired[m, p] * Batches[p]) <= Availability[m]
);

% Constraint 3: The total cost of using each machine should not exceed the selling price of the parts produced
constraint forall(m in 1..M) (
  MachineCosts[m] * sum(p in 1..P) (TimeRequired[m, p] * Batches[p]) <= sum(p in 1..P) (Prices[p] * Batches[p])
);

% Objective
solve maximize sum(p in 1..P) (Prices[p] * Batches[p]) - sum(m in 1..M) (MachineCosts[m] * sum(p in 1..P) (TimeRequired[m, p] * Batches[p]));