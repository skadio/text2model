include "globals.mzn";

% Parameters
int: M; % Number of machines
int: P; % Number of parts
array[1..M, 1..P] of int: TimeRequired; % Time required to produce a batch of part p on machine m
array[1..M] of int: MachineCosts; % Cost associated with running machine m
array[1..M] of int: Availability; % Availability of machine m per month
array[1..P] of int: Prices; % Selling price of a batch of part p
array[1..P] of int: MinBatches; % Minimum number of batches of part p that should be produced

% Decision variables
array[1..P] of var 0..100: Batches; % Number of batches of each part to be produced

% Objective
var int: profit;
constraint profit = sum(p in 1..P) (Prices[p] * Batches[p]) - sum(m in 1..M) (MachineCosts[m] * sum(p in 1..P) (TimeRequired[m,p] * Batches[p]));
solve maximize profit;

% Constraints
constraint forall(p in 1..P) (Batches[p] >= MinBatches[p]);
constraint forall(m in 1..M) (sum(p in 1..P) (TimeRequired[m,p] * Batches[p]) <= Availability[m]);
constraint forall(m in 1..M-1) (sum(p in 1..P) (TimeRequired[m,p] * Batches[p]) + sum(p in 1..P) (TimeRequired[m+1,p] * Batches[p]) <= Availability[m] + Availability[m+1]);

% Output
output [ "Profit: " ++ show(profit) ++ "\n" ] ++
[ if fix(Batches[p]) > 0 then "Produce " ++ show(Batches[p]) ++ " batches of part " ++ show(p) ++ "\n" else "" endif | p in 1..P ];