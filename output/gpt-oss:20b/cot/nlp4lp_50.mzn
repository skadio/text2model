% Parameters
int: NumShifts;
array[1..NumShifts] of int: OfficersNeeded;
array[1..NumShifts] of int: ShiftCosts;

% Variables
array[1..NumShifts] of var 0..max(OfficersNeeded) of int: start;

% Constraints
constraint forall(s in 1..NumShifts) (
    if s == 1 then
        start[1] >= OfficersNeeded[1]
    else
        start[s] + start[s-1] >= OfficersNeeded[s]
);

% Objective
solve minimize sum(s in 1..NumShifts) start[s] * ShiftCosts[s];