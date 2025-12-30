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

% Ensure that the number of batches produced for each part is at least the minimum required
constraint forall(p in 1..P) (
  Batches[p] >= MinBatches[p]
);

% Ensure that the total time required to produce all batches does not exceed the availability of each machine
% Note that machine M and machine M-1 can share availability
constraint forall(m in 1..M-2) (
  sum(p in 1..P) (Batches[p] * TimeRequired[m, p]) <= Availability[m]
);
constraint sum(p in 1..P) (Batches[p] * TimeRequired[M-1, p] + Batches[p] * TimeRequired[M, p]) <= Availability[M-1] + Availability[M];

% Ensure that the cost of running the machines does not exceed the revenue from selling the parts
% This is to ensure that the manufacturer is not operating at a loss
constraint sum(p in 1..P) (Batches[p] * Prices[p]) >= sum(m in 1..M) (sum(p in 1..P) (Batches[p] * TimeRequired[m, p]) * MachineCosts[m]);

% Objective
solve maximize sum(p in 1..P) (Batches[p] * Prices[p]) - sum(m in 1..M) (sum(p in 1..P) (Batches[p] * TimeRequired[m, p]) * MachineCosts[m]);