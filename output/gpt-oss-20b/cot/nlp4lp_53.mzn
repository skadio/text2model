% Parameters
int: M;
int: P;
array[1..M, 1..P] of int: TimeRequired;
array[1..M] of int: MachineCosts;
array[1..M] of int: Availability;
array[1..P] of int: Prices;
array[1..P] of int: MinBatches;
array[1..M] of int: ExtraCosts;
array[1..M] of int: MaxExtra;

% Variables
array[1..P] of var int: B;          % number of batches per part
array[1..M] of var int: E;          % extra hours purchased per machine

% Constraints
constraint
  % Minimum batch requirements
  forall(p in 1..P)(B[p] >= MinBatches[p]) /\
  % Extra hours bounds
  forall(m in 1..M)(E[m] >= 0 /\ E[m] <= MaxExtra[m]) /\
  % Machine availability constraints
  forall(m in 1..M)(
    sum(p in 1..P)(TimeRequired[m,p] * B[p]) <= Availability[m] + E[m]
  );

% Objective
solve maximize
  sum(p in 1..P)(Prices[p] * B[p]) -
  sum(m in 1..M)(
    MachineCosts[m] * sum(p in 1..P)(TimeRequired[m,p] * B[p]) +
    ExtraCosts[m] * E[m]
  );