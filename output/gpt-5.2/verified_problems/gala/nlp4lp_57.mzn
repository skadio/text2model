include "globals.mzn";

%======================
% Input data (from .dzn)
%======================
int: NumMachines;                      % M
int: NumParts;                         % P

array[1..NumMachines, 1..NumParts] of int: TimeRequired;  % hours per batch
array[1..NumMachines] of int: MachineCosts;               % $ per machine-hour (non-labor)
array[1..NumMachines] of int: Availability;               % normal hours capacity (ignored for machine 1)
array[1..NumParts] of int: Prices;                        % $ per batch
array[1..NumParts] of int: MinBatches;                    % min batches

int: StandardCost;                     % $ per labor-hour (machine 1 normal)
int: OvertimeCost;                     % $ extra per labor-hour in overtime (machine 1)
array[1..NumMachines] of int: OvertimeHour;               % overtime hours available (we use for machine 1)

%======================
% Decisions
%======================
array[1..NumParts] of var 0..int_max: Batches;  % batches of each part (100 units each)

%======================
% Helper expressions
%======================
array[1..NumMachines] of var 0..int_max: HoursUsed =
  [ sum(p in 1..NumParts)( TimeRequired[m,p] * Batches[p] ) | m in 1..NumMachines ];

% Machine 1 is outsourced: labor costs with standard + overtime tier.
var 0..int_max: LaborNormalHours;
var 0..int_max: LaborOvertimeHours;

constraint LaborNormalHours <= OvertimeHour[1];     % normal hours limit before overtime
constraint LaborNormalHours + LaborOvertimeHours = HoursUsed[1];

% Machine-hour costs for machines 2..M (no overtime mentioned for them)
var int: Revenue = sum(p in 1..NumParts)( Prices[p] * Batches[p] );

var int: NonLaborMachineCost =
  sum(m in 2..NumMachines)( MachineCosts[m] * HoursUsed[m] );

var int: LaborCost =
  StandardCost * LaborNormalHours + (StandardCost + OvertimeCost) * LaborOvertimeHours;

var int: Profit = Revenue - NonLaborMachineCost - LaborCost;

%======================
% Constraints
%======================

% Contract minimums
constraint forall(p in 1..NumParts)( Batches[p] >= MinBatches[p] );

% Capacity constraints for machines 2..M (machine 1 availability disregarded)
constraint forall(m in 2..NumMachines)(
  HoursUsed[m] <= Availability[m]
);

% (Optional) If overtime were relevant for machines 2..M, it is not specified in description;
% so we do not allow overtime for them.

%======================
% Objective
%======================
solve maximize Profit;

%======================
% Output
%======================
output [
  "Batches = ", show(Batches), "\n",
  "HoursUsed = ", show(HoursUsed), "\n",
  "LaborNormalHours = ", show(LaborNormalHours), "\n",
  "LaborOvertimeHours = ", show(LaborOvertimeHours), "\n",
  "Revenue = ", show(Revenue), "\n",
  "NonLaborMachineCost = ", show(NonLaborMachineCost), "\n",
  "LaborCost = ", show(LaborCost), "\n",
  "Profit = ", show(Profit), "\n"
];