int: M;
int: P;

set of int: MACHINES = 1..M;
set of int: PARTS = 1..P;

array[MACHINES, PARTS] of int: TimeRequired;   % hours per batch (100 units)
array[MACHINES] of int: MachineCosts;          % cost per hour
array[MACHINES] of int: Availability;          % available hours per month
array[PARTS] of int: Prices;                   % revenue per batch
array[PARTS] of int: SetupTime;                % setup hours on machine 1 if part is produced

% Decision variables
array[PARTS] of var 0..int_max: Batches;       % number of batches produced
array[PARTS] of var bool: Produce;             % 1 if part produced, 0 otherwise (to trigger setup)

% Link production to indicator (no minimum production; setup only if produced)
constraint forall(p in PARTS) (
  Batches[p] >= Produce[p] /\
  Batches[p] <= int_max * Produce[p]
);

% Machine capacity constraints (setup only on machine 1)
constraint forall(m in MACHINES) (
  sum(p in PARTS)(
    TimeRequired[m,p] * Batches[p]
    + (if m == 1 then SetupTime[p] * bool2int(Produce[p]) else 0 endif)
  ) <= Availability[m]
);

% Objective: maximize profit = revenue - operating costs
var int: Profit =
  sum(p in PARTS)(Prices[p] * Batches[p])
  - sum(m in MACHINES)(
      MachineCosts[m] * sum(p in PARTS)(
        TimeRequired[m,p] * Batches[p]
        + (if m == 1 then SetupTime[p] * bool2int(Produce[p]) else 0 endif)
      )
    );

solve maximize Profit;

output [
  "Profit = ", show(Profit), "\n",
  "Batches = ", show(Batches), "\n",
  "Produce = ", show([bool2int(Produce[p]) | p in PARTS]), "\n"
];