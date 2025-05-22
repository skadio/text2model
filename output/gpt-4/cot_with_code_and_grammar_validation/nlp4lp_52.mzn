% Parameters
int: M; % Number of machines
int: P; % Number of parts to be produced
array[1..M, 1..P] of int: TimeRequired; % Time required to produce a batch of part p on machine m
array[1..M] of int: MachineCosts; % Cost associated with running machine m
array[1..M] of int: Availability; % Availability of machine m per month
array[1..P] of int: Prices; % Selling price of a batch of part p
array[1..P] of int: MinBatches; % Minimum number of batches of part p that should be produced

% Variables
array[1..P] of var 0..1000: Batches; % Number of batches of each part to be produced

% Constraints
constraint forall(p in 1..P)(Batches[p] >= MinBatches[p]); % Minimum number of batches constraint
constraint forall(m in 1..M-1)(sum(p in 1..P)(TimeRequired[m,p]*Batches[p]) + sum(p in 1..P)(TimeRequired[m+1,p]*Batches[p]) <= Availability[m] + Availability[m+1]); % Machine availability constraint
constraint sum(p in 1..P)(TimeRequired[M,p]*Batches[p]) <= Availability[M]; % Machine availability constraint for the last machine

% Objective
var int: Profit = sum(p in 1..P)(Prices[p]*Batches[p]) - sum(m in 1..M)(MachineCosts[m]*sum(p in 1..P)(TimeRequired[m,p]*Batches[p]));
solve maximize Profit;