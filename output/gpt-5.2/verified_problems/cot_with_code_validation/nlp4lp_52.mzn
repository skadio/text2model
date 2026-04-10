% Parameters
int: M;
int: P;

array[1..M, 1..P] of int: TimeRequired;
array[1..M] of int: MachineCosts;
array[1..M] of int: Availability;
array[1..P] of int: Prices;
array[1..P] of int: MinBatches;

% Variables
array[1..P] of var 0..intmax: Batches;

% Constraints: minimum production requirements
constraint forall(p in 1..P) (
  Batches[p] >= MinBatches[p]
);

% Availability constraints:
% - Machines 1..M-2 have individual limits
constraint forall(m in 1..M-2 where M >= 3) (
  sum(p in 1..P)(TimeRequired[m,p] * Batches[p]) <= Availability[m]
);

% - Machines M-1 and M share availability, so only the combined limit applies (if M >= 2)
constraint (M < 2) \/
  (sum(p in 1..P)((TimeRequired[M-1,p] + TimeRequired[M,p]) * Batches[p]) <= Availability[M-1] + Availability[M]);

% Objective: maximize profit = revenue - operating costs
solve maximize
  sum(p in 1..P)(Prices[p] * Batches[p])
  - sum(m in 1..M, p in 1..P)(MachineCosts[m] * TimeRequired[m,p] * Batches[p]);