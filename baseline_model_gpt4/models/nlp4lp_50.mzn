% Number of shifts
int: NumShifts;

% Number of officers needed for each shift
array[1..NumShifts] of int: OfficersNeeded;

% Cost of assigning an officer to each shift
array[1..NumShifts] of int: ShiftCosts;

% Decision variable: number of officers assigned to each shift
array[1..NumShifts] of var 0..sum(OfficersNeeded): OfficersAssigned;

% Constraint: each officer works for two consecutive shifts
constraint forall(i in 1..NumShifts-1) (
  OfficersAssigned[i] + OfficersAssigned[i+1] >= OfficersNeeded[i]
);

% Constraint: for the last shift, the number of officers assigned should be equal to the number of officers needed
constraint OfficersAssigned[NumShifts] = OfficersNeeded[NumShifts];

% Objective: minimize the total cost
var int: TotalCost = sum(i in 1..NumShifts) (OfficersAssigned[i] * ShiftCosts[i]);
minimize TotalCost;

% Output the solution
output ["Total cost: ", show(TotalCost), "\nOfficers assigned: "] ++ [show(OfficersAssigned[i]) | i in 1..NumShifts];