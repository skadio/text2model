% Parameters
int: NumShifts;                                  % Number of shifts
set of int: S = 1..NumShifts;                    % Shift index set

array[S] of int: OfficersNeeded;                 % Required officers on duty in each shift
array[S] of int: ShiftCosts;                     % Cost per officer starting work at each shift

% Variables
array[S] of var 0..max(OfficersNeeded): StartOfficers;  % Officers starting at shift s (work s and next shift)
var 0..max(OfficersNeeded) * NumShifts: TotalCost;      % Total assignment cost

% Constraints
% Coverage: shift s is covered by officers who start at s and those who started at s-1 (cyclic wrap)
constraint
  forall(s in S) (
    StartOfficers[s] + StartOfficers[if s = 1 then NumShifts else s - 1 endif]
    >= OfficersNeeded[s]
  );

% Total cost definition
constraint
  TotalCost = sum(s in S)(StartOfficers[s] * ShiftCosts[s]);

% Objective
solve minimize TotalCost;