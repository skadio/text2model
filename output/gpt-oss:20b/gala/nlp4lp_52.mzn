include "globals.mzn";

/* --- Input data --- */
int: M;                       % number of machines
int: P;                       % number of parts

array[1..M, 1..P] of int: TimeRequired;     % hours per batch per machine
array[1..M] of int: MachineCosts;           % cost per hour for each machine
array[1..M] of int: Availability;           % total available hours per month for each machine
array[1..P] of int: Prices;                 % selling price per batch of each part
array[1..P] of int: MinBatches;             % minimum batches that must be produced

/* --- Decision variables --- */
array[1..P] of var int: batches;            % number of batches produced for each part

/* --- Constraints --- */
constraint forall(p in 1..P) (
    batches[p] >= MinBatches[p]
);

/* Total machine usage */
var int: totalUsage = sum(m in 1..M, p in 1..P) (
    TimeRequired[m,p] * batches[p]
);

/* All machines share the same total availability */
constraint totalUsage <= sum(m in 1..M) Availability[m];

/* --- Objective: maximize profit --- */
var int: totalProfit = sum(p in 1..P) (
    Prices[p] * batches[p]
) - sum(m in 1..M, p in 1..P) (
    TimeRequired[m,p] * batches[p] * MachineCosts[m]
);

solve maximize totalProfit;

/* --- Output --- */
output [
    "Batches produced per part: ", show(batches), "\n",
    "Total profit: ", show(totalProfit), "\n"
];