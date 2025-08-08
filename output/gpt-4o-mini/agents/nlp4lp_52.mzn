include "globals.mzn";

int: M;  % Number of machines
int: P;  % Number of parts
array[1..M, 1..P] of int: TimeRequired;  % Time required to produce a batch of part p on machine m
array[1..M] of int: MachineCosts;  % Cost associated with running machine m
array[1..M] of int: Availability;  % Availability of machine m per month
array[1..P] of int: Prices;  % Selling price of a batch of part p
array[1..P] of int: MinBatches;  % Minimum number of batches of part p that should be produced

int: n = 100;  % Total number of batches
array[1..P] of var 0..n: batches;  % Batches of each part

% Count the total number of batches produced
var 0..n: total_batches;
constraint total_batches = sum(p in 1..P)(batches[p]);

% Global cardinality constraint to ensure minimum batches are produced
array[1..P] of var 0..n: counts;
constraint global_cardinality(batches, 1..P, counts);
constraint forall(p in 1..P)(counts[p] >= MinBatches[p]);

% Cumulative constraint for machine availability
array[1..M] of var 0..max(Availability): used_hours;  % Hours used on each machine
constraint forall(m in 1..M)(
    used_hours[m] = sum(p in 1..P)(TimeRequired[m, p] * batches[p])
);
constraint forall(m in 1..M)(used_hours[m] <= Availability[m]);

% Profit calculation
var 0..sum(p in 1..P)(Prices[p] * n): profit;
constraint profit = sum(p in 1..P)(Prices[p] * batches[p]) - sum(m in 1..M)(MachineCosts[m] * used_hours[m]);

% Objective: Maximize profit
solve maximize profit;

% Output
output [
    "Batches = ", show(batches), "\n",
    "Profit = ", show(profit), "\n"
];