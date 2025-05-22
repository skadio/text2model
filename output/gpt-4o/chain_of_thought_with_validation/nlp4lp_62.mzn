int: M;
int: P;

set of int: MACHINES = 1..M;
set of int: PARTS    = 1..P;

array[MACHINES, PARTS] of int: TimeRequired;
array[MACHINES]            of int: MachineCosts;
array[MACHINES]            of int: Availability;
array[PARTS]               of int: Prices;
array[PARTS]               of int: SetupTime;

/* Upper bound on batches of each part (tightest machine capacity) */
array[PARTS] of int: MaxBatchesPerPart =
  [ min( [ if TimeRequired[m,p] > 0 then Availability[m] div TimeRequired[m,p]
           else Availability[m] endif | m in MACHINES ] )
  | p in PARTS ];

/* Uniform upper bound so a single domain can be used for all x[p] */
int: XUB = max(p in PARTS)(MaxBatchesPerPart[p]);

/* Decision variables */
array[PARTS]    of var 0..XUB: x;              % batches of each part
array[PARTS]    of var bool:  produced;        % produced[p] = 1 iff x[p] > 0
array[MACHINES] of var int:   machineTime;     % hours used on each machine
var int: totalCost;
var int: totalRevenue;
var int: profit;

/* Link production quantity and produced flag */
constraint
  forall(p in PARTS)(
    (x[p] > 0) <-> produced[p] /\
    x[p] <= MaxBatchesPerPart[p]
  );

/* Machine-time calculations (setup on machine 1 only) */
constraint
  forall(m in MACHINES)(
    machineTime[m] =
      sum(p in PARTS)(
        TimeRequired[m,p] * x[p] +
        (if m == 1 then SetupTime[p] * bool2int(produced[p]) else 0 endif)
      )
  );

/* Capacity limits */
constraint
  forall(m in MACHINES)(
    machineTime[m] <= Availability[m]
  );

/* Cost, revenue, and profit */
constraint totalCost    = sum(m in MACHINES)(MachineCosts[m] * machineTime[m]);
constraint totalRevenue = sum(p in PARTS)(Prices[p] * x[p]);
constraint profit       = totalRevenue - totalCost;

/* Objective */
solve maximize profit;