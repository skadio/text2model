% Parameters
int: M; % number of machines
int: P; % number of part types

set of int: MACHINES = 1..M; % machine index set
set of int: PARTS    = 1..P; % part index set

array[MACHINES, PARTS] of int: TimeRequired; % hours required on machine m per batch of part p
array[MACHINES] of int: MachineCosts;        % cost per hour of operating machine m
array[MACHINES] of int: Availability;        % available hours for machine m per month
array[PARTS] of int: Prices;                 % selling price per batch of part p
array[PARTS] of int: SetupTime;              % setup hours on machine 1 if producing part p (once per month if produced)

% Variables
array[PARTS] of var 0..max(Availability): Batches; % number of batches of each part to produce (>= 0)
array[PARTS] of var 0..1: ProducePart;             % 1 if any batch of part p is produced this month, else 0

% Constraints

% Link production indicator to whether any batches of part p are produced
constraint
  forall(p in PARTS) (
    (Batches[p] > 0) <-> (ProducePart[p] = 1)
  );

% Machine capacity constraints (including setup time on machine 1 if the part is produced)
constraint
  forall(m in MACHINES) (
    sum(p in PARTS) (
      TimeRequired[m, p] * Batches[p]
      + (if m = 1 then SetupTime[p] * ProducePart[p] else 0 endif)
    ) <= Availability[m]
  );

% Objective
solve maximize
  sum(p in PARTS) (
    Prices[p] * Batches[p]
  )
  - sum(m in MACHINES) (
      MachineCosts[m] * sum(p in PARTS) (
        TimeRequired[m, p] * Batches[p]
        + (if m = 1 then SetupTime[p] * ProducePart[p] else 0 endif)
      )
    );