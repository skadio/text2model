% Parameters
int: P;
int: M;

array[1..M, 1..P] of int: TimeRequired;
array[1..M] of int: MachineCosts;
array[1..M] of int: Availability;
array[1..P] of int: Prices;
array[1..P] of int: MinBatches;

% A loose upper bound derived from machine availability
int: BigM = max([ Availability[m] | m in 1..M ]);

% Variables
array[1..P] of var 0..BigM: Batches;

% Constraints
constraint
  forall(p in 1..P)(
    Batches[p] >= MinBatches[p]
  );

constraint
  forall(m in 1..M)(
    sum(p in 1..P)( TimeRequired[m, p] * Batches[p] ) <= Availability[m]
  );

% Objective
var int: Profit =
     sum(p in 1..P)( Prices[p] * Batches[p] )
   - sum(m in 1..M)(
       MachineCosts[m] * sum(p in 1..P)( TimeRequired[m, p] * Batches[p] )
     );

solve maximize Profit;