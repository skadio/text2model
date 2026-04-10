% Parameters
int: NumShifts;                              % Number of shifts
set of int: S = 1..NumShifts;                % Index set of shifts

array[S] of int: OfficersNeeded;             % Officers required on duty in shift s
array[S] of int: ShiftCosts;                 % Cost of starting an officer at shift s

% Variables
array[S] of var 0..max(OfficersNeeded): StartOfficers;   % Officers whose 2-shift duty starts at shift s
array[S] of var 0..max(OfficersNeeded): OnDuty;          % Total officers on duty in shift s (derived)

% Constraints
% Link start decisions to on-duty staffing (each officer works two consecutive shifts)
constraint
  forall(s in S) (
    OnDuty[s] =
      StartOfficers[s] +
      StartOfficers[ if s = 1 then NumShifts else s - 1 endif ]   % wrap-around for previous shift
  );

% Meet (at least) the required number of officers in every shift
constraint
  forall(s in S) (
    OnDuty[s] >= OfficersNeeded[s]
  );

% Objective
solve minimize sum(s in S)(ShiftCosts[s] * StartOfficers[s]);