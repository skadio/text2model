include "globals.mzn";

% Parameters
int: NumMachines;
int: NumParts;
array[1..NumMachines, 1..NumParts] of int: TimeRequired;
array[1..NumMachines] of int: MachineCosts;
array[1..NumMachines] of int: Availability;
array[1..NumParts] of int: Prices;
array[1..NumParts] of int: MinBatches;
int: StandardCost;
int: OvertimeCost;
array[1..NumMachines] of int: OvertimeHour;

% Decision Variables
array[1..NumParts] of var 0..100: Batches; % Number of batches of each part to produce

% Objective
var int: Profit;
constraint Profit = sum(p in 1..NumParts)(Prices[p]*Batches[p]) - sum(m in 1..NumMachines)(MachineCosts[m]*sum(p in 1..NumParts)(TimeRequired[m,p]*Batches[p])) - StandardCost*sum(m in 2..NumMachines)(min(Availability[m], sum(p in 1..NumParts)(TimeRequired[m,p]*Batches[p]))) - OvertimeCost*sum(m in 2..NumMachines)(max(0, sum(p in 1..NumParts)(TimeRequired[m,p]*Batches[p]) - Availability[m]));

% Constraints
constraint forall(m in 1..NumMachines)(sum(p in 1..NumParts)(TimeRequired[m,p]*Batches[p]) <= Availability[m] + OvertimeHour[m]);
constraint forall(p in 1..NumParts)(Batches[p] >= MinBatches[p]);

% Solve
solve maximize Profit;

% Output
output ["Profit: ", show(Profit), "\n"] ++ ["Batches: "] ++ [show(Batches[p]) | p in 1..NumParts];