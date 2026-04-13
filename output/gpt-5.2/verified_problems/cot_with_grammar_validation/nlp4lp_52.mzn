% Parameters
int: M;
int: P;

array[1..M, 1..P] of int: TimeRequired;
array[1..M] of int: MachineCosts;
array[1..M] of int: Availability;

array[1..P] of int: Prices;
array[1..P] of int: MinBatches;

% Variables
array[1..P] of var int: Batches;

% Constraints
constraint forall(p in 1..P) (
  Batches[p] >= MinBatches[p]
);

% Machine availability constraints for machines 1..M-2 (individual limits apply)
constraint forall(m in 1..M-2) (
  sum(p in 1..P)(TimeRequired[m,p] * Batches[p]) <= Availability[m]
);

% Shared availability for machines M-1 and M (individual limits disregarded)
constraint
  sum(p in 1..P)(
    (TimeRequired[M-1,p] + TimeRequired[M,p]) * Batches[p]
  ) <= Availability[M-1] + Availability[M];

% Objective
var int: Profit =
  sum(p in 1..P)(Prices[p] * Batches[p])
  - sum(m in 1..M, p in 1..P)(MachineCosts[m] * TimeRequired[m,p] * Batches[p]);

solve maximize Profit;