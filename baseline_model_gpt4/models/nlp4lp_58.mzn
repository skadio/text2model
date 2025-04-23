include "globals.mzn";

% Number of machines
int: M;
% Number of parts to be produced
int: P;

% Time required to produce each part 'p' on machine 'm'
array[1..M, 1..P] of int: TimeRequired;
% Cost associated with each machine 'm'
array[1..M] of int: MachineCosts;
% Availability in hours of each machine 'm' per month
array[1..M] of int: Availability;
% Price obtained from selling each part 'p'
array[1..P] of int: Prices;
% Minimum number of batches of part 'p' that must be produced
array[1..P] of int: MinBatches;
% Standard cost for a machine to run for one hour
int: StandardCost;
% Overtime cost for a machine to run for one hour beyond the standard availability
int: OvertimeCost;
% Numbers of overtime hours available for a machine to run beyond standard availability
int: OvertimeHour;
% The minimum profit the manufacturer wants to achieve
int: MinProfit;

% Decision variable: number of batches of each part to produce
array[1..P] of var 0..100: Batches;

% Objective: maximize profit
var int: profit = sum(p in 1..P) (Prices[p] * Batches[p]) - sum(m in 1..M) (MachineCosts[m] * sum(p in 1..P) (TimeRequired[m,p] * Batches[p]));

% Constraints
constraint forall(m in 2..M) (sum(p in 1..P) (TimeRequired[m,p] * Batches[p]) <= Availability[m]);
constraint sum(p in 1..P) (TimeRequired[1,p] * Batches[p]) <= Availability[1] + OvertimeHour;
constraint forall(p in 1..P) (Batches[p] >= MinBatches[p]);
constraint profit >= MinProfit;

% The cost of the first machine includes the standard cost and the overtime cost
constraint sum(p in 1..P) (TimeRequired[1,p] * Batches[p]) * StandardCost + max(0, sum(p in 1..P) (TimeRequired[1,p] * Batches[p]) - Availability[1]) * OvertimeCost <= MachineCosts[1];

% Solve
solve maximize profit;