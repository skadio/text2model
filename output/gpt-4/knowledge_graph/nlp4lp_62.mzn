include "globals.mzn";

% Parameters
int: M; % Number of machines
int: P; % Number of types of parts
array[1..M, 1..P] of int: TimeRequired; % Time required to produce a batch on machine m for part p
array[1..M] of int: MachineCosts; % Cost of operating machine m for a month
array[1..M] of int: Availability; % Time each machine m is available for production each month
array[1..P] of int: Prices; % Price at which part p can be sold
array[1..P] of int: SetupTime; % Setup time required before producing a batch of part p

% Variables
array[1..M, 1..P] of var 0..100: Batches; % Number of batches produced on machine m for part p

% Constraints
constraint forall(m in 1..M)(sum(p in 1..P)(TimeRequired[m,p]*Batches[m,p] + if Batches[m,p] > 0 then SetupTime[p] else 0) <= Availability[m]);

% Objective
var int: profit = sum(p in 1..P)(Prices[p]*sum(m in 1..M)(Batches[m,p])) - sum(m in 1..M)(MachineCosts[m]);
solve maximize profit;

% Output
output [ "Profit: " ++ show(profit) ++ "\n" ] ++
[ if fix(Batches[m,p]) > 0 then "Machine " ++ show(m) ++ " produces " ++ show(Batches[m,p]) ++ " batches of part " ++ show(p) ++ "\n" else "" endif | m in 1..M, p in 1..P ];