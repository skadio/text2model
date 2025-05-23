% Parameters
int: M; % Number of machines
int: P; % Number of parts to be produced
array[1..M, 1..P] of int: TimeRequired; % Time required to produce a batch of part p on machine m
array[1..M] of int: MachineCosts; % Cost associated with running machine m
array[1..M] of int: Availability; % Availability of machine m per month
array[1..P] of int: Prices; % Selling price of a batch of part p
array[1..P] of int: MinBatches; % Minimum number of batches of part p that should be produced

% Variables
array[1..M, 1..P] of var 0..max(m in 1..M)(Availability[m] div min(p in 1..P)(TimeRequired[m, p])): Batches; % Number of batches of each part produced on each machine

% Constraints
constraint forall(m in 1..M, p in 1..P) (
  Batches[m, p] * TimeRequired[m, p] <= Availability[m]
);

constraint forall(m in 1..M-1) (
  sum(p in 1..P) (Batches[m, p] * TimeRequired[m, p] + Batches[m+1, p] * TimeRequired[m+1, p]) <= Availability[m] + Availability[m+1]
);

constraint forall(p in 1..P) (
  sum(m in 1..M) (Batches[m, p]) >= MinBatches[p]
);

% Objective
var int: Profit = sum(m in 1..M, p in 1..P) (Prices[p] * Batches[m, p] - MachineCosts[m] * Batches[m, p] * TimeRequired[m, p]);
solve maximize Profit;