% Parameters
int: NumShifts;
set of int: S = 1..NumShifts;

array[S] of int: OfficersNeeded;
array[S] of int: ShiftCosts;

% Auxiliary upper bound on the number of officers that can start any shift
int: MaxOfficers = sum(OfficersNeeded);

% Variables
array[S] of var 0..MaxOfficers: StartShift;   % officers whose first of two consecutive shifts is s

% Constraints
constraint
  forall(s in S)(
    StartShift[s] +
    StartShift[ if s == 1 then NumShifts else s - 1 endif ] >= OfficersNeeded[s]
  );

% Objective
solve minimize sum(s in S)(StartShift[s] * ShiftCosts[s]);