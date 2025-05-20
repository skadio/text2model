include "globals.mzn";

% Parameters
int: NumShifts; % Number of shifts
array[1..NumShifts] of int: OfficersNeeded; % Number of officers needed for each shift
array[1..NumShifts] of int: ShiftCosts; % Cost of assigning an officer to each shift

% Variables
array[1..NumShifts] of var 0..max(OfficersNeeded): OfficersAssigned; % Number of officers assigned to each shift

% Constraints
constraint forall(s in 1..NumShifts-1) (
  OfficersAssigned[s] + OfficersAssigned[s+1] >= OfficersNeeded[s]
);

constraint forall(s in 2..NumShifts) (
  OfficersAssigned[s-1] + OfficersAssigned[s] >= OfficersNeeded[s]
);

% Objective
var int: TotalCost = sum(s in 1..NumShifts) (OfficersAssigned[s] * ShiftCosts[s]);
solve minimize TotalCost;

% Output
output ["Total Cost: ", show(TotalCost), "\n"] ++
["Officers Assigned: "] ++ [show(OfficersAssigned[s]) | s in 1..NumShifts];