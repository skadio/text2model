% Parameters
int: M;
int: P;

array[1..M, 1..P] of int: TimeRequired;
array[1..M] of int: MachineCosts;
array[1..M] of int: Availability;
array[1..P] of int: Prices;
array[1..P] of int: MinBatches;

% Variables
int: maxAvail = max(Availability);
int: maxTimeReq = max([TimeRequired[m,p] | m in 1..M, p in 1..P]);
int: maxBatches =
  if maxTimeReq > 0 then
    (M * maxAvail) div maxTimeReq
  else
    0
  endif;

array[1..P] of var 0..maxBatches: Batches;

% Constraints
constraint forall(p in 1..P) (
  Batches[p] >= MinBatches[p]
);

% For machines 1..M-2: enforce individual availability
constraint forall(m in 1..M-2) (
  sum(p in 1..P)(TimeRequired[m,p] * Batches[p]) <= Availability[m]
);

% For machines M-1 and M: combined availability (shared)
constraint
  sum(p in 1..P)(TimeRequired[M-1,p] * Batches[p]) +
  sum(p in 1..P)(TimeRequired[M,p] * Batches[p])
  <= Availability[M-1] + Availability[M];

% Objective
solve maximize
  sum(p in 1..P)(Prices[p] * Batches[p])
  - sum(m in 1..M, p in 1..P)(MachineCosts[m] * TimeRequired[m,p] * Batches[p]);