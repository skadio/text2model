% Parameters
int: P; % Number of parts
int: M; % Number of machines
array[1..M, 1..P] of int: TimeRequired; % Time required to produce one batch of part p on machine m
array[1..M] of int: MachineCosts; % Cost associated with using machine m
array[1..M] of int: Availability; % Availability of machine m per month
array[1..P] of int: Prices; % Selling price of one batch of part p
array[1..P] of int: MinBatches; % Minimum number of batches of part p to be produced

% Variables
array[1..P] of var 0..Availability[1]: Batches; % Number of batches of each part to be produced

% Constraints

% Constraint 1: The total time required to produce all batches of each part on each machine should not exceed the availability of that machine
constraint forall(m in 1..M)(
  sum(p in 1..P)(TimeRequired[m,p]*Batches[p]) <= Availability[m]
);

% Constraint 2: The number of batches of each part produced should be at least the minimum number of batches required for that part
constraint forall(p in 1..P)(
  Batches[p] >= MinBatches[p]
);

% Constraint 3: The total cost of using each machine should not exceed the selling price of the batches produced
constraint forall(p in 1..P)(
  sum(m in 1..M)(TimeRequired[m,p]*MachineCosts[m]*Batches[p]) <= Prices[p]*Batches[p]
);

% Objective
solve maximize sum(p in 1..P)(Prices[p]*Batches[p] - sum(m in 1..M)(TimeRequired[m,p]*MachineCosts[m]*Batches[p]));