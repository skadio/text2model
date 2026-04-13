% Parameters
int: M;
int: P;

array[1..M, 1..P] of int: TimeRequired;
array[1..M] of int: MachineCosts;
array[1..M] of int: Availability;
array[1..P] of int: Prices;
array[1..P] of int: MinBatches;

% Variables
int: maxBatches = max([
  min([ if TimeRequired[m,p] > 0 then Availability[m] div TimeRequired[m,p] else 1000000000 endif
        | m in 1..M ])
  | p in 1..P
]);

array[1..P] of var 0..maxBatches: Batches;

var int: Revenue;
var int: OperatingCost;
var int: Profit;

% Constraints
constraint
  forall(p in 1..P) (
    Batches[p] >= MinBatches[p]
  );

% Machine capacity constraints for machines 1..M-2 (individual limits apply)
constraint
  if M >= 3 then
    forall(m in 1..M-2) (
      sum(p in 1..P) (TimeRequired[m,p] * Batches[p]) <= Availability[m]
    )
  else
    true
  endif;

% Shared capacity constraint for machines M-1 and M (individual limits disregarded)
constraint
  if M >= 2 then
    sum(p in 1..P) ((TimeRequired[M-1,p] + TimeRequired[M,p]) * Batches[p]) <= Availability[M-1] + Availability[M]
  else
    sum(p in 1..P) (TimeRequired[1,p] * Batches[p]) <= Availability[1]
  endif;

% Accounting definitions
constraint
  Revenue = sum(p in 1..P) (Prices[p] * Batches[p]);

constraint
  OperatingCost = sum(m in 1..M, p in 1..P) (MachineCosts[m] * TimeRequired[m,p] * Batches[p]);

constraint
  Profit = Revenue - OperatingCost;

% Objective
solve maximize Profit;