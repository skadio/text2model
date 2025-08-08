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
var int: Batches[1..NumParts];
var int: labor_hours;
var int: cost_m1;

% Constraints
constraint labor_hours = sum(p in 1..NumParts) TimeRequired[1,p] * Batches[p];
constraint cost_m1 = StandardCost * min(labor_hours, OvertimeHour[1]) + OvertimeCost * max(0, labor_hours - OvertimeHour[1]);

constraint forall(m in 2..NumMachines) (
    sum(p in 1..NumParts) TimeRequired[m,p] * Batches[p] <= Availability[m] + OvertimeHour[m]
);

constraint forall(p in 1..NumParts) (
    Batches[p] >= MinBatches[p]
);

% Objective
solve maximize sum(p in 1..NumParts) Prices[p] * Batches[p] - (sum(m in 1..NumMachines) MachineCosts[m] + cost_m1);