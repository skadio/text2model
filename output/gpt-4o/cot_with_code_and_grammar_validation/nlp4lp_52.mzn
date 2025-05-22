% Parameters
int: M;                                           % Number of machines
int: P;                                           % Number of parts

set of int: MACHINES = 1..M;
set of int: PARTS    = 1..P;

array[MACHINES, PARTS] of int: TimeRequired;      % Hours of machine m for one batch of part p
array[MACHINES]            of int: MachineCosts;  % Cost per hour of machine m
array[MACHINES]            of int: Availability;  % Monthly availability of machine m  (hours)
array[PARTS]               of int: Prices;        % Selling price per batch of part p
array[PARTS]               of int: MinBatches;    % Contractual minimum batches of part p

% Derived constants -----------------------------------------------------------
% Smallest positive processing time (to build a coarse upper bound)
int: minTimePerBatch =
    min([ TimeRequired[m,p] | m in MACHINES, p in PARTS where TimeRequired[m,p] > 0 ]);

int: MaxBatches =
    (sum(m in MACHINES)(Availability[m])) div minTimePerBatch;  % coarse global upper bound

% Ensure the special sharing rule makes sense
constraint M >= 2;     % need at least two machines so M-1 exists

% Variables
array[PARTS] of var 0..MaxBatches: Batches;      % decision vars: batches of each part
var int: Revenue =               sum(p in PARTS)(Prices[p] * Batches[p]);
var int: OperatingCost =         sum(m in MACHINES)(
                                     MachineCosts[m] *
                                     sum(p in PARTS)(TimeRequired[m,p] * Batches[p])
                                  );
var int: Profit = Revenue - OperatingCost;

% Constraints
% Contractual minimum for every part
constraint forall(p in PARTS)( Batches[p] >= MinBatches[p] );

% Machine‐availability limits for all machines except the last two
constraint
    forall(m in MACHINES where m <= M-2)(
        sum(p in PARTS)( TimeRequired[m,p] * Batches[p] ) <= Availability[m]
    );

% Shared availability for machines M-1 and M
constraint
    sum(p in PARTS)(
        (TimeRequired[M-1,p] + TimeRequired[M,p]) * Batches[p]
    ) <= Availability[M-1] + Availability[M];

% Objective
solve maximize Profit;