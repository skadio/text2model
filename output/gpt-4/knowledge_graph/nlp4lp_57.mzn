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

% Variables
array[1..NumMachines, 1..NumParts] of var 0..100: Batches;

% Constraints
constraint forall(m in 1..NumMachines)(
  sum(p in 1..NumParts)(TimeRequired[m,p]*Batches[m,p]) <= Availability[m] + OvertimeHour[m]
);

constraint forall(p in 1..NumParts)(
  sum(m in 1..NumMachines)(Batches[m,p]) >= MinBatches[p]
);

% Objective
var int: profit = sum(p in 1..NumParts)(Prices[p]*sum(m in 1..NumMachines)(Batches[m,p])) - 
                  sum(m in 1..NumMachines)(MachineCosts[m]*min(sum(p in 1..NumParts)(TimeRequired[m,p]*Batches[m,p]), Availability[m])) - 
                  StandardCost*sum(m in 1..NumMachines)(min(sum(p in 1..NumParts)(TimeRequired[m,p]*Batches[m,p]), Availability[m])) - 
                  OvertimeCost*sum(m in 1..NumMachines)(max(0, sum(p in 1..NumParts)(TimeRequired[m,p]*Batches[m,p]) - Availability[m]));

solve maximize profit;

% Output
output [ "Profit: " ++ show(profit) ++ "\n" ] ++
       [ if fix(Batches[m,p]) > 0 then "Machine " ++ show(m) ++ " produces " ++ show(Batches[m,p]) ++ " batches of part " ++ show(p) ++ "\n" else "" endif | m in 1..NumMachines, p in 1..NumParts ];