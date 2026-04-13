% Parameters
int: M; % number of machines
int: P; % number of parts

array[1..M, 1..P] of int: TimeRequired;  % hours per batch on machine m for part p
array[1..M] of int: MachineCosts;        % cost per hour for machine m
array[1..M] of int: Availability;        % available hours for machine m
array[1..P] of int: Prices;              % revenue per batch of part p
array[1..P] of int: SetupTime;           % setup hours on machine 1 if part p is produced

% Variables
array[1..P] of var int: Batches;         % batches produced of each part (>= 0)
array[1..P] of var bool: Produce;        % whether part p is produced (triggers setup on machine 1)

% Constraints
constraint forall(p in 1..P) (Batches[p] >= 0);

% Link production to setup decision
constraint forall(p in 1..P) (
  Batches[p] > 0 <-> Produce[p]
);

% Machine capacity constraints (machine 1 includes setup if produced)
constraint
  sum(p in 1..P) (TimeRequired[1,p] * Batches[p] + SetupTime[p] * bool2int(Produce[p])) <= Availability[1];

constraint forall(m in 2..M) (
  sum(p in 1..P) (TimeRequired[m,p] * Batches[p]) <= Availability[m]
);

% Objective
solve maximize
  sum(p in 1..P) (Prices[p] * Batches[p])
  - sum(p in 1..P) (MachineCosts[1] * SetupTime[p] * bool2int(Produce[p]))
  - sum(m in 1..M, p in 1..P) (MachineCosts[m] * TimeRequired[m,p] * Batches[p]);