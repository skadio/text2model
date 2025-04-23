include "globals.mzn";

% Number of machines
int: M;
% Number of parts
int: P;

% Time required to produce a batch on machine m for part p
array[1..M, 1..P] of int: TimeRequired;
% Cost of operating machine m for a month
array[1..M] of int: MachineCosts;
% Time each machine m is available for production each month
array[1..M] of int: Availability;
% Price at which part p can be sold
array[1..P] of int: Prices;
% Setup time required before producing a batch of part p
array[1..P] of int: SetupTime;

% Decision variable: number of batches of each part to produce
array[1..P] of var 0..Availability[1] div (max(TimeRequired[1,..])+max(SetupTime)): Batches;

% Objective: maximize profit
var int: profit = sum(p in 1..P) (Prices[p] * Batches[p]) - sum(m in 1..M) (MachineCosts[m] * sum(p in 1..P) (TimeRequired[m,p] * Batches[p]));

% Constraint: machine availability
constraint forall(m in 1..M) (sum(p in 1..P) (TimeRequired[m,p] * Batches[p]) <= Availability[m]);

% Constraint: setup time for first machine
constraint forall(p in 1..P) (TimeRequired[1,p] * Batches[p] + SetupTime[p] <= Availability[1]);

% Solve
solve maximize profit;

% Output
output ["Profit: ", show(profit), "\n"] ++ ["Batches: "] ++ [show(Batches[p]) | p in 1..P];