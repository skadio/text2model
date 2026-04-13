% Parameters
int: P; % Number of parts
int: M; % Number of machines

array[1..M, 1..P] of int: TimeRequired; % Hours required on machine m to produce one batch of part p
array[1..M] of int: MachineCosts;       % Operating cost per hour for machine m
array[1..M] of int: Availability;       % Available hours per month for machine m

array[1..P] of int: Prices;             % Selling price per batch of part p
array[1..P] of int: MinBatches;         % Minimum required batches to produce for part p

% Variables
array[1..P] of var int: Batches; % Number of batches of each part to produce

% Constraints
% Meet contractual minimum production for each part
constraint
  forall(p in 1..P) (
    Batches[p] >= MinBatches[p]
  );

% Respect monthly machine-hour availability on each machine
constraint
  forall(m in 1..M) (
    sum(p in 1..P) (TimeRequired[m, p] * Batches[p]) <= Availability[m]
  );

% Objective
% Maximize profit = revenue - machine operating costs
solve maximize
  sum(p in 1..P) (
    Prices[p] * Batches[p]
    - sum(m in 1..M) (MachineCosts[m] * TimeRequired[m, p] * Batches[p])
  );