include "globals.mzn";

% Parameters
int: M; % Number of machines
int: P; % Number of parts
array[1..M, 1..P] of int: TimeRequired; % Time required to produce a batch of part p on machine m
array[1..M] of int: MachineCosts; % Cost associated with running machine m
array[1..M] of int: Availability; % Availability of machine m for production each month
array[1..P] of int: Prices; % Price obtained from selling a batch of part p
array[1..P] of int: MinBatches; % Minimum number of batches of part p that should be produced
array[1..M] of int: ExtraCosts; % Extra cost incurred when running machine m beyond regular operation
array[1..M] of int: MaxExtra; % Maximum extra hours machine m can be run

% Variables
array[1..P] of var 0..100: Batches; % Number of batches of each part to produce
array[1..M] of var 0..MaxExtra: ExtraHours; % Extra hours to run each machine

% Constraints
constraint forall(m in 1..M) (
  sum(p in 1..P) (TimeRequired[m,p] * Batches[p]) <= Availability[m] + ExtraHours[m]
);

constraint forall(p in 1..P) (
  Batches[p] >= MinBatches[p]
);

constraint forall(m in 1..M) (
  ExtraHours[m] <= MaxExtra[m]
);

% Objective
var int: Profit = sum(p in 1..P) (Prices[p] * Batches[p]) - sum(m in 1..M) (MachineCosts[m] * (sum(p in 1..P) (TimeRequired[m,p] * Batches[p]) + ExtraCosts[m] * ExtraHours[m]));

solve maximize Profit;

% Output
output [ "Profit: " ++ show(Profit) ++ "\n" ] ++
[ if fix(Batches[p]) > 0 then "Produce " ++ show(fix(Batches[p])) ++ " batches of part " ++ show(p) ++ "\n" else "" endif | p in 1..P ];