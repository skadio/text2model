include "globals.mzn";

% Parameters
int: M; % Number of machines
int: P; % Number of parts to be produced
array[1..M, 1..P] of int: TimeRequired; % Time required to produce a batch of part p on machine m
array[1..M] of int: MachineCosts; % Cost associated with running machine m
array[1..M] of int: Availability; % Availability of machine m per month
array[1..P] of int: Prices; % Selling price of a batch of part p
array[1..P] of int: MinBatches; % Minimum number of batches of part p that should be produced

% Variables
array[1..M, 1..P] of var 0..Availability[1..M]: Batches; % Number of batches of part p to be produced on machine m

% Constraints
constraint forall(m in 1..M, p in 1..P) (
    Batches[m, p] * TimeRequired[m, p] <= Availability[m]
);

constraint forall(p in 1..P) (
    sum(m in 1..M) (Batches[m, p]) >= MinBatches[p]
);

% Objective
var int: profit = sum(m in 1..M, p in 1..P) (Prices[p] * Batches[m, p]) - sum(m in 1..M) (MachineCosts[m] * sum(p in 1..P) (Batches[m, p] * TimeRequired[m, p]));

solve maximize profit;

% Output
output [ "Profit: " ++ show(profit) ++ "\n" ] ++
[ if fix(Batches[m, p]) > 0 then "Machine " ++ show(m) ++ " produces " ++ show(Batches[m, p]) ++ " batches of part " ++ show(p) ++ "\n" else "" endif | m in 1..M, p in 1..P ];