% Parameters
int: M;
int: P;

set of int: MACHINES = 1..M;
set of int: PARTS   = 1..P;

array[MACHINES, PARTS] of int: TimeRequired;
array[MACHINES]            of int: MachineCosts;
array[MACHINES]            of int: Availability;
array[PARTS]               of int: Prices;
array[PARTS]               of int: MinBatches;

% Derived constants (used only to give an upper bound to the decision variables)
int: MinTime           = min( [ TimeRequired[m,p] | m in MACHINES, p in PARTS ] );
int: TotalAvailability = sum( m in MACHINES )( Availability[m] );
int: MaxBatchBound     = TotalAvailability div MinTime;

% Variables
array[PARTS] of var int: Batches;

% Constraints
constraint
  forall(p in PARTS)(
    MinBatches[p] <= Batches[p] /\ Batches[p] <= MaxBatchBound
  );

constraint
  forall(m in 1..M-2)(
    sum(p in PARTS)( TimeRequired[m,p] * Batches[p] ) <= Availability[m]
  );

constraint
  if M >= 2 then
    sum(p in PARTS)(
      TimeRequired[M-1,p] * Batches[p] + TimeRequired[M,p] * Batches[p]
    ) <= Availability[M-1] + Availability[M]
  else
    true
  endif;

% Objective
var int: Profit =
  sum(p in PARTS)( Prices[p] * Batches[p] ) -
  sum(m in MACHINES)(
    MachineCosts[m] * sum(p in PARTS)( TimeRequired[m,p] * Batches[p] )
  );

solve maximize Profit;