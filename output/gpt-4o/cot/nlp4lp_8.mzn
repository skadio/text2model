% Parameters
int: NumParts;
int: NumMachines;

set of int: PARTS    = 1..NumParts;
set of int: MACHINES = 1..NumMachines;

array[PARTS, MACHINES] of int: Time;
array[PARTS]              of int: Profit;
array[MACHINES]           of int: Capacity;

int: BigM = sum(s in MACHINES)(Capacity[s]);

% Variables
array[PARTS] of var 0..BigM: Produce;

% Constraints
constraint
  forall(s in MACHINES) (
    sum(k in PARTS)(Time[k,s] * Produce[k]) <= Capacity[s]
  );

% Objective
solve maximize sum(k in PARTS)(Profit[k] * Produce[k]);