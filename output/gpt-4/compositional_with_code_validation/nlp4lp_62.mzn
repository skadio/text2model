% Parameters
int: M; % The number of machines available
int: P; % The number of types of parts to produce
array[1..M, 1..P] of int: TimeRequired; % The time required to produce a batch on machine m for part p
array[1..M] of int: MachineCosts; % The cost of operating machine m for a month
array[1..M] of int: Availability; % The time each machine m is available for production each month
array[1..P] of int: Prices; % The price at which part p can be sold
array[1..P] of int: SetupTime; % The setup time required before producing a batch of part p

% Variables
array[1..P] of var 0..100: Batches; % The number of batches of each part to produce each month

% Constraints

% The total time required to produce all batches of each part on each machine should not exceed the machine's availability
constraint forall(m in 1..M)(
  sum(p in 1..P)(Batches[p] * TimeRequired[m,p]) <= Availability[m]
);

% The setup time for the first machine should be considered only once for each part type
constraint forall(p in 1..P)(
  Batches[p] * TimeRequired[1,p] + SetupTime[p] <= Availability[1]
);

% The total cost of operating all machines should not exceed the total revenue from selling all parts
constraint sum(m in 1..M)(MachineCosts[m] * Availability[m]) <= sum(p in 1..P)(Prices[p] * Batches[p]);

% The number of batches produced should be non-negative
constraint forall(p in 1..P)(
  Batches[p] >= 0
);

% Objective
solve maximize sum(p in 1..P)(Prices[p] * Batches[p]) - sum(m in 1..M)(MachineCosts[m] * Availability[m]);