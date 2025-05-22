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
array[1..NumParts] of var 0..100: Batches;
array[1..NumMachines] of var 0..1000: OvertimeUsed;

% Constraints
constraint forall(m in 1..NumMachines)(sum(p in 1..NumParts)(TimeRequired[m,p]*Batches[p]) <= Availability[m] + OvertimeUsed[m]);
constraint forall(m in 1..NumMachines)(OvertimeUsed[m] <= OvertimeHour[m]);
constraint forall(p in 1..NumParts)(Batches[p] >= MinBatches[p]);

% Objective
var int: TotalCost = sum(m in 1..NumMachines)(MachineCosts[m]*Availability[m] + OvertimeUsed[m]*OvertimeCost);
var int: TotalRevenue = sum(p in 1..NumParts)(Prices[p]*Batches[p]);
var int: Profit = TotalRevenue - TotalCost;
solve maximize Profit;