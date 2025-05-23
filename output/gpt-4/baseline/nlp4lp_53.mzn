include "globals.mzn";

% Number of machines
int: M;
% Number of parts
int: P;

% Time required to produce a batch of part p on machine m
array[1..M, 1..P] of int: TimeRequired;

% Cost associated with running machine m
array[1..M] of int: MachineCosts;

% Availability of machine m for production each month
array[1..M] of int: Availability;

% Price obtained from selling a batch of part p
array[1..P] of int: Prices;

% Minimum number of batches of part p that should be produced
array[1..P] of int: MinBatches;

% Extra cost incurred when running machine m beyond regular operation
array[1..M] of float: ExtraCosts;

% Maximum extra hours machine m can be run
array[1..M] of int: MaxExtra;

% Decision variable: number of batches of each part to produce
array[1..P] of var 0..100: Batches;

% Decision variable: extra hours to run each machine
array[1..M] of var 0..MaxExtra: ExtraHours;

% Objective: maximize profit
var int: Profit = sum(p in 1..P) (Prices[p] * Batches[p]) - sum(m in 1..M) ((MachineCosts[m] * sum(p in 1..P) (TimeRequired[m,p] * Batches[p])) + (ExtraCosts[m] * ExtraHours[m]));

% Constraints
constraint forall(m in 1..M) (sum(p in 1..P) (TimeRequired[m,p] * Batches[p]) <= Availability[m] + ExtraHours[m]);
constraint forall(p in 1..P) (Batches[p] >= MinBatches[p]);

% Solve
solve maximize Profit;

% Output
output ["Profit: ", show(Profit), "\n"] ++ ["Batches: "] ++ [show(Batches[p]) | p in 1..P] ++ ["\n"] ++ ["ExtraHours: "] ++ [show(ExtraHours[m]) | m in 1..M];