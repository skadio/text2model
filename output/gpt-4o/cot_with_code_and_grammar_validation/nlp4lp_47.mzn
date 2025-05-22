% Parameters
int: P;
int: M;

array[1..M, 1..P] of int: TimeRequired;  % hours needed on machine m for one batch of part p
array[1..M] of int: MachineCosts;        % cost per hour of machine m
array[1..M] of int: Availability;        % available machine‐hours for machine m in the month
array[1..P] of int: Prices;              % selling price for one batch of part p
array[1..P] of int: MinBatches;          % contractual minimum batches for part p

% Derived data
array[1..P] of int: MaxBatches =
  [ min( [ Availability[m] div TimeRequired[m,p] | m in 1..M where TimeRequired[m,p] > 0 ] )
  | p in 1..P
  ];

% Variables
array[1..P] of var 0..max(MaxBatches): Batches;   % decision: batches of each part produced

% Constraints
constraint
  forall(p in 1..P)(
    Batches[p] >= MinBatches[p] /\         % meet minimum contractual requirement
    Batches[p] <= MaxBatches[p]            % cannot exceed capacity‐based upper bound
  );

constraint
  forall(m in 1..M)(
    sum(p in 1..P)(TimeRequired[m,p] * Batches[p]) <= Availability[m]   % machine‐hour limits
  );

% Objective
var int: Profit =
  sum(p in 1..P)(Prices[p] * Batches[p]) -
  sum(m in 1..M)(
    MachineCosts[m] * sum(p in 1..P)(TimeRequired[m,p] * Batches[p])
  );

solve maximize Profit;