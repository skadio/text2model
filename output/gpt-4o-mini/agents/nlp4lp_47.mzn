include "globals.mzn";

int: P;  % Number of parts
int: M;  % Number of machines
array[1..M, 1..P] of int: TimeRequired;  % Time required to produce one batch of part p on machine m
array[1..M] of int: MachineCosts;  % Cost associated with using machine m
array[1..M] of int: Availability;  % Availability of machine m per month
array[1..P] of int: Prices;  % Selling price of one batch of part p
array[1..P] of int: MinBatches;  % Minimum number of batches of part p to be produced

% Define the maximum number of batches that can be produced
int: max_batches = 100;  % Assuming a maximum of 100 batches for simplicity

% Variables
array[1..P] of var 0..max_batches: batches;  % Number of batches for each part

% Constraints
array[1..P] of int: min_batches = MinBatches;
array[1..P] of var 0..max_batches: counts;

% Ensure that the minimum number of batches for each part is produced
constraint global_cardinality(batches, [1..P], counts);
constraint forall(p in 1..P)(counts[p] >= min_batches[p]);

% Ensure machine availability is not exceeded
array[1..M] of var 0..sum(batches): machine_usage;  % Total time used on each machine
constraint forall(m in 1..M)(
    machine_usage[m] = sum(p in 1..P)(batches[p] * TimeRequired[m, p])
);

constraint forall(m in 1..M)(machine_usage[m] <= Availability[m]);

% Objective: Maximize profit
var int: profit = sum(p in 1..P)(Prices[p] * batches[p]) - sum(m in 1..M)(MachineCosts[m] * machine_usage[m]);

% Solve
solve maximize profit;

% Output
output [ "Batches = ", show(batches), "\nProfit = ", show(profit), "\n" ];