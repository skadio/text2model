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
var int: FixedMachineCost;
var int: LaborCost;
var int: Profit;

% Constraints
constraint forall(p in PARTS) (
  Batches[p] >= MinBatches[p]
);

constraint forall(p in PARTS) (
  Batches[p] >= 0
);

constraint forall(m in MACHINES) (
  HoursUsed[m] = sum(p in PARTS)(TimeRequired[m,p] * Batches[p])
);

% Machine availability constraints:
% - Machine 1 is outsourced: ignore individual availability conditions (no cap applied).
% - Machines 2..M are limited by regular hours + overtime hours.
constraint forall(m in MACHINES where m != 1) (
  HoursUsed[m] <= Availability[m] + OvertimeHour[m]
);

% Overtime accounting:
% - For machine 1: allow any nonnegative overtime amount (no cap), and treat all hours beyond Availability[1] as overtime.
% - For machines 2..M: overtime is capped and also at least the excess beyond Availability.
constraint OvertimeUsed[1] >= HoursUsed[1] - Availability[1];
constraint OvertimeUsed[1] >= 0;

constraint forall(m in MACHINES where m != 1) (
  OvertimeUsed[m] >= HoursUsed[m] - Availability[m]
);
constraint forall(m in MACHINES where m != 1) (
  0 <= OvertimeUsed[m] /\ OvertimeUsed[m] <= OvertimeHour[m]
);

% Define objective components
constraint Revenue = sum(p in PARTS)(Prices[p] * Batches[p]);

constraint FixedMachineCost = sum(m in MACHINES)(MachineCosts[m]);

constraint LaborCost =
  StandardCost * sum(m in MACHINES)(HoursUsed[m])
  + OvertimeCost * sum(m in MACHINES)(OvertimeUsed[m]);

constraint Profit = Revenue - FixedMachineCost - LaborCost;

% Objective
solve maximize Profit;