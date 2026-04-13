% Parameters
int: NumMachines;
int: NumParts;

set of int: MACHINES = 1..NumMachines;
set of int: PARTS = 1..NumParts;

array[MACHINES, PARTS] of int: TimeRequired;
array[MACHINES] of int: MachineCosts;
array[MACHINES] of int: Availability;

array[PARTS] of int: Prices;
array[PARTS] of int: MinBatches;

int: StandardCost;
int: OvertimeCost;
array[MACHINES] of int: OvertimeHour;

% Variables
array[PARTS] of var int: Batches;

array[MACHINES] of var int: HoursUsed;
array[MACHINES] of var int: OvertimeUsed;

var int: Revenue;
var int: OperatingCost;
var int: Profit;

% Constraints
constraint forall(p in PARTS) (
  Batches[p] >= MinBatches[p]
);

constraint forall(m in MACHINES) (
  HoursUsed[m] = sum(p in PARTS)(TimeRequired[m,p] * Batches[p])
);

% Machines 2..NumMachines are limited by their own availability + overtime.
% Machine 1 availability can be disregarded (outsourced), but overtime accounting still applies.
constraint forall(m in MACHINES where m != 1) (
  HoursUsed[m] <= Availability[m] + OvertimeHour[m]
);

% Define overtime usage for all machines, including machine 1
constraint forall(m in MACHINES) (
  OvertimeUsed[m] >= 0
);
constraint forall(m in MACHINES) (
  OvertimeUsed[m] <= OvertimeHour[m]
);
constraint forall(m in MACHINES) (
  OvertimeUsed[m] >= HoursUsed[m] - Availability[m]
);

constraint Revenue = sum(p in PARTS)(Prices[p] * Batches[p]);

% Base machine operating costs (excluding machine 1, which is outsourced)
constraint OperatingCost =
    sum(m in MACHINES where m != 1)(MachineCosts[m] * HoursUsed[m])
  + StandardCost * HoursUsed[1]
  + OvertimeCost * OvertimeUsed[1];

constraint Profit = Revenue - OperatingCost;

% Objective
solve maximize Profit;