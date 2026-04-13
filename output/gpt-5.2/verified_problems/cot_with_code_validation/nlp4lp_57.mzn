% Parameters
int: NumMachines;
int: NumParts;

set of int: MACHINES = 1..NumMachines;
set of int: PARTS = 1..NumParts;

array[MACHINES, PARTS] of int: TimeRequired;   % hours per batch on machine m for part p
array[MACHINES] of int: MachineCosts;          % cost per hour for in-house machines (m != 1)
array[MACHINES] of int: Availability;          % regular hours available (used as threshold for machine 1 labor too)
array[PARTS] of int: Prices;                   % revenue per batch
array[PARTS] of int: MinBatches;               % minimum batches required

int: StandardCost;                             % labor cost per hour up to Availability[1] for outsourced machine 1
int: OvertimeCost;                             % labor cost per hour beyond Availability[1] for outsourced machine 1
array[MACHINES] of int: OvertimeHour;          % overtime capacity for machines m != 1

% Decision variables
array[PARTS] of var 0..int_max: Batches;

% Derived variables (hours used per machine)
array[MACHINES] of var 0..int_max: TotalHoursUsed;
array[MACHINES] of var 0..int_max: OvertimeHoursUsed;

var int: Revenue;
var int: MachineOpCost;
var int: LaborCost;
var int: Profit;

% Constraints
constraint forall(p in PARTS) (Batches[p] >= MinBatches[p]);

% Total hours on each machine from production plan
constraint forall(m in MACHINES) (
  TotalHoursUsed[m] = sum(p in PARTS)(TimeRequired[m,p] * Batches[p])
);

% Machine 1 outsourced: ignore its availability/overtime capacity constraints,
% but labor cost uses Availability[1] as the standard-hours threshold.
constraint OvertimeHoursUsed[1] = 0;

% Machines 2..M: limited regular availability, with bounded overtime
constraint forall(m in MACHINES where m != 1) (
  TotalHoursUsed[m] <= Availability[m] + OvertimeHour[m]
);
constraint forall(m in MACHINES where m != 1) (
  OvertimeHoursUsed[m] >= TotalHoursUsed[m] - Availability[m]
);
constraint forall(m in MACHINES where m != 1) (
  OvertimeHoursUsed[m] <= OvertimeHour[m]
);

% Revenue and costs
constraint Revenue = sum(p in PARTS)(Prices[p] * Batches[p]);

% In-house machine operating cost for machines 2..M (per hour)
constraint MachineOpCost =
  sum(m in MACHINES where m != 1)(MachineCosts[m] * TotalHoursUsed[m]);

% Labor cost for outsourced machine 1: piecewise using max (avoids min/max on var for both sides)
constraint LaborCost =
  StandardCost * TotalHoursUsed[1]
  + (OvertimeCost - StandardCost) * max(0, TotalHoursUsed[1] - Availability[1]);

constraint Profit = Revenue - MachineOpCost - LaborCost;

% Objective
solve maximize Profit;

output [
  "Batches = ", show(Batches), "\n",
  "Profit = ", show(Profit), "\n",
  "Revenue = ", show(Revenue), "\n",
  "MachineOpCost = ", show(MachineOpCost), "\n",
  "LaborCost = ", show(LaborCost), "\n"
];