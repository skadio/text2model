% Parameters
int: NumShifts;
set of int: SHIFTS = 1..NumShifts;

array[SHIFTS] of int: OfficersNeeded;
array[SHIFTS] of int: ShiftCosts;

% Variables
int: MaxOfficers = sum(s in SHIFTS)(OfficersNeeded[s]);

array[SHIFTS] of var 0..MaxOfficers: Start;   % officers whose first of two consecutive shifts is s

% Constraints
constraint
  forall(s in SHIFTS) (
    Start[s] + Start[ if s == 1 then NumShifts else s - 1 endif ] >= OfficersNeeded[s]
  );

% Objective
solve minimize sum(s in SHIFTS)(Start[s] * ShiftCosts[s]);