% Parameters
int: P;                    % Number of parts
int: M;                    % Number of machines

set of int: PARTS    = 1..P;
set of int: MACHINES = 1..M;

array[MACHINES, PARTS] of int: TimeRequired;   % hours per batch
array[MACHINES]          of int: MachineCosts; % cost per machine-hour
array[MACHINES]          of int: Availability; % monthly machine hours
array[PARTS]             of int: Prices;       % revenue per batch
array[PARTS]             of int: MinBatches;   % contractual minimum output

% Auxiliary constants (upper bounds for decision variables)
array[PARTS] of int: MaxBatches =
   [ min( [ Availability[m] div max(1,TimeRequired[m,p])
           | m in MACHINES ] )
   | p in PARTS ];

int: GlobalUpperBound = max(MaxBatches);

% Variables
array[PARTS] of var 0..GlobalUpperBound: Batches;

% Constraints
constraint
   forall(p in PARTS)(
      Batches[p] >= MinBatches[p] /\
      Batches[p] <= MaxBatches[p]
   );

constraint
   forall(m in MACHINES)(
      sum(p in PARTS)( TimeRequired[m,p] * Batches[p] ) <= Availability[m]
   );

% Objective
solve maximize
   sum(p in PARTS)( Prices[p] * Batches[p] )
 - sum(m in MACHINES)(
       MachineCosts[m] *
       sum(p in PARTS)( TimeRequired[m,p] * Batches[p] )
   );