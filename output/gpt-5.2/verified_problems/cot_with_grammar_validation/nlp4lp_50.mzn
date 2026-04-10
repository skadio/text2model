% Parameters
int: NumShifts;
set of int: S = 1..NumShifts;

array[S] of int: OfficersNeeded;
array[S] of int: ShiftCosts;

% Variables
array[S] of var int: Start;         % officers starting at shift s (work shifts s and s+1)
var int: TotalCost;

% Constraints
constraint forall(s in S) (Start[s] >= 0);

% coverage: officers on duty in shift s are those who started in s and in previous shift
constraint forall(s in S) (
  Start[s] + Start[if s = 1 then NumShifts else s - 1 endif] >= OfficersNeeded[s]
);

% cost
constraint TotalCost = sum(s in S)(ShiftCosts[s] * Start[s]);

% Objective
solve minimize TotalCost;