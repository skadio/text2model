% Parameters
int: M;
int: P;
array[1..M,1..P] of int: TimeRequired;
array[1..M] of int: MachineCosts;
array[1..M] of int: Availability;
array[1..P] of int: Prices;
array[1..P] of int: MinBatches;

% Variables
array[1..P] of var int: 0..1000: batches;

% Constraints
constraint
  forall(p in 1..P) (batches[p] >= MinBatches[p]);

constraint
  forall(m in 1..M-2) (
    sum(p in 1..P) (TimeRequired[m,p] * batches[p]) <= Availability[m]
  )
  /\ 
  (if M >= 2 then
     sum(p in 1..P) ((TimeRequired[M-1,p] + TimeRequired[M,p]) * batches[p]) <= Availability[M-1] + Availability[M]
   else
     true
  );

% Objective
solve maximize
  sum(p in 1..P) Prices[p] * batches[p]
  - sum(m in 1..M, p in 1..P) MachineCosts[m] * TimeRequired[m,p] * batches[p];