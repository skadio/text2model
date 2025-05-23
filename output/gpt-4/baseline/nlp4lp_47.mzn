include "globals.mzn";

% Parameters
int: P; % Number of parts
int: M; % Number of machines
array[1..M, 1..P] of int: TimeRequired; % Time required to produce one batch of part p on machine m
array[1..M] of int: MachineCosts; % Cost associated with using machine m
array[1..M] of int: Availability; % Availability of machine m per month
array[1..P] of int: Prices; % Selling price of one batch of part p
array[1..P] of int: MinBatches; % Minimum number of batches of part p to be produced

% Decision variables
array[1..P] of var 0..100: Batches; % Number of batches of each part to produce

% Constraints
constraint forall(m in 1..M) (
  sum(p in 1..P) (TimeRequired[m,p] * Batches[p]) <= Availability[m]
);

constraint forall(p in 1..P) (
  Batches[p] >= MinBatches[p]
);

% Objective
var int: profit = sum(p in 1..P) (Prices[p] * Batches[p]) - sum(m in 1..M) (MachineCosts[m] * sum(p in 1..P) (TimeRequired[m,p] * Batches[p]));

solve maximize profit;

% Output
output [ "Batches: " ++ show(Batches) ++ "\n" ++ "Profit: " ++ show(profit) ];