% Parameters
int: NumShifts;
array[1..NumShifts] of int: OfficersNeeded;
array[1..NumShifts] of int: ShiftCosts;

% Variables
array[1..NumShifts] of var 0..sum(OfficersNeeded): OfficersAssigned;

% Constraints
constraint forall(s in 1..NumShifts-1) (
  OfficersAssigned[s] + OfficersAssigned[s+1] >= OfficersNeeded[s+1]
);
constraint OfficersAssigned[NumShifts] + OfficersAssigned[1] >= OfficersNeeded[1];

% Objective
var int: TotalCost = sum(s in 1..NumShifts) (OfficersAssigned[s] * ShiftCosts[s]);
solve minimize TotalCost;