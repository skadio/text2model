% Parameters
int: M; % number of machines
int: P; % number of part types

array[1..M, 1..P] of int: TimeRequired; % hours required on machine m per batch of part p
array[1..M] of int: MachineCosts;       % cost per operating hour for machine m
array[1..M] of int: Availability;       % available operating hours per month for machine m
array[1..P] of int: Prices;             % selling price per batch of part p
array[1..P] of int: SetupTime;          % setup hours on machine 1 required if part p is produced

% Variables
array[1..P] of var int: BatchesProduced; % number of batches (of 100) of part p produced
array[1..P] of var bool: ProducePart;    % true if any batch of part p is produced (to trigger setup on machine 1)

% Constraints
%--------------------------------------------------------------------
% Link production indicator to batch quantities (setup trigger)
%--------------------------------------------------------------------
constraint
  forall(p in 1..P) (
    (BatchesProduced[p] > 0) <-> ProducePart[p]
  );

%--------------------------------------------------------------------
% Non-negativity of production quantities (no minimum, but cannot be negative)
%--------------------------------------------------------------------
constraint
  forall(p in 1..P) (
    BatchesProduced[p] >= 0
  );

%--------------------------------------------------------------------
% Machine capacity constraints (including setup time on machine 1 only)
%--------------------------------------------------------------------

% Capacity for machine 1: processing time + setup time if part is produced
constraint
  sum(p in 1..P) (
    TimeRequired[1,p] * BatchesProduced[p] + SetupTime[p] * bool2int(ProducePart[p])
  ) <= Availability[1];

% Capacity for machines 2..M: only processing time
constraint
  forall(m in 2..M) (
    sum(p in 1..P) (
      TimeRequired[m,p] * BatchesProduced[p]
    ) <= Availability[m]
  );

% Objective
solve maximize
  sum(p in 1..P) (
    Prices[p] * BatchesProduced[p]
  )
  - (
    sum(p in 1..P) (
      MachineCosts[1] * (TimeRequired[1,p] * BatchesProduced[p] + SetupTime[p] * bool2int(ProducePart[p]))
    )
    + sum(m in 2..M, p in 1..P) (
      MachineCosts[m] * TimeRequired[m,p] * BatchesProduced[p]
    )
  );