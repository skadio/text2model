% Parameters
int: M;
int: P;

set of int: MACHINES = 1..M;
set of int: PARTS    = 1..P;

array[MACHINES, PARTS] of int: TimeRequired;
array[MACHINES]            of int: MachineCosts;
array[MACHINES]            of int: Availability;
array[PARTS]               of int: Prices;
array[PARTS]               of int: MinBatches;

% A large constant
int: BIG = 1_000_000;

% Safe (not too small) upper bounds for every part
array[PARTS] of int: UpperBound =
   [ let {
         int: total_avail = sum(m in MACHINES)(Availability[m]);
         int: total_time  = sum(m in MACHINES)(TimeRequired[m,p]);
       } in
       if total_time > 0 then total_avail div total_time else BIG endif
     | p in PARTS ];

% Decision variables
array[PARTS] of var 0..UpperBound[p]: Batches;

% Minimum-batch requirements
constraint
   forall(p in PARTS)(
      Batches[p] >= MinBatches[p]
   );

% Capacity constraints for machines 1 … M-2
constraint
   if M > 2 then
      forall(m in 1..M-2)(
         sum(p in PARTS)( TimeRequired[m,p] * Batches[p] ) <= Availability[m]
      )
   else
      true
   endif;

% Shared capacity for machines M-1 and M
constraint
   if M >= 2 then
      sum(p in PARTS)(
         (TimeRequired[M-1,p] + TimeRequired[M,p]) * Batches[p]
      ) <= Availability[M-1] + Availability[M]
   else
      % Single-machine case
      sum(p in PARTS)( TimeRequired[1,p] * Batches[p] ) <= Availability[1]
   endif;

% Objective: maximise profit
var int: Profit =
      sum(p in PARTS)( Prices[p] * Batches[p] )
    - sum(m in MACHINES, p in PARTS)(
        MachineCosts[m] * TimeRequired[m,p] * Batches[p]
      );

solve maximize Profit;