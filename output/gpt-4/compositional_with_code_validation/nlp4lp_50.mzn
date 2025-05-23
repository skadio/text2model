% Parameters
int: NumShifts; % Number of shifts for which officers are needed
array[1..NumShifts] of int: OfficersNeeded; % Number of officers needed for each shift
array[1..NumShifts] of int: ShiftCosts; % Cost of assigning an officer to each shift

% Variables
array[1..NumShifts] of var 0..sum(OfficersNeeded): OfficersAssigned; % Number of officers assigned to each shift

% Constraints

% Each officer works for two consecutive shifts
constraint forall(s in 1..NumShifts-1) (
  OfficersAssigned[s] + OfficersAssigned[s+1] >= OfficersNeeded[s]
);

% For the last shift, the officers assigned should be at least the officers needed
constraint OfficersAssigned[NumShifts] >= OfficersNeeded[NumShifts];

% Objective
solve minimize sum(s in 1..NumShifts) (OfficersAssigned[s] * ShiftCosts[s]);