% Parameters
int: M;
int: P;

set of int: MACHINES = 1..M;
set of int: PARTS    = 1..P;

array[MACHINES, PARTS] of int: TimeRequired;
array[MACHINES]              of int: MachineCosts;
array[MACHINES]              of int: Availability;
array[PARTS]                 of int: Prices;
array[PARTS]                 of int: SetupTime;

% Auxiliary constants derived from parameters
int: TotalAvailability = sum(m in MACHINES)(Availability[m]);
int: MinPositiveTime   = min([TimeRequired[m,p] | m in MACHINES, p in PARTS where TimeRequired[m,p] > 0]);
int: MaxBatches        = TotalAvailability div MinPositiveTime;

% Variables
array[PARTS]   of var 0..MaxBatches: batches;  % number of 100-part batches produced
array[PARTS]   of var 0..1:          produce;  % 1 if the part is produced
array[MACHINES] of var 0..TotalAvailability: totalHours;

var int: revenue;
var int: cost;

% Link production indicator and batch quantity
constraint
    forall(p in PARTS) (
        batches[p] >= produce[p] /\
        batches[p] <= MaxBatches * produce[p]
    );

% Machine-hour usage (setup time only on machine 1)
constraint
    forall(m in MACHINES) (
        totalHours[m] =
            sum(p in PARTS)(TimeRequired[m,p] * batches[p]) +
            (if m == 1 then sum(p in PARTS)(SetupTime[p] * produce[p]) else 0 endif)
    );

% Capacity limits
constraint
    forall(m in MACHINES) (
        totalHours[m] <= Availability[m]
    );

% Revenue and cost
constraint
    revenue = sum(p in PARTS)(Prices[p] * batches[p]);

constraint
    cost = sum(m in MACHINES)(MachineCosts[m] * totalHours[m]);

% Objective
solve maximize revenue - cost;