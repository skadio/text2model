% Parameters
int: NumShifts;
array[1..NumShifts] of int: OfficersNeeded;
array[1..NumShifts] of int: ShiftCosts;

% Variables
array[1..NumShifts] of var 0..max(OfficersNeeded): OfficersAssigned;

% Constraints
constraint forall(s in 1..NumShifts-1) (
  OfficersAssigned[s] + OfficersAssigned[s+1] >= OfficersNeeded[s]
);
constraint OfficersAssigned[NumShifts] + OfficersAssigned[1] >= OfficersNeeded[NumShifts];

% Objective
var int: TotalCost = sum(s in 1..NumShifts) (OfficersAssigned[s] * ShiftCosts[s]);
solve minimize TotalCost;