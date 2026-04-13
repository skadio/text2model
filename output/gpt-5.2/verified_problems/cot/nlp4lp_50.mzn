% Parameters
int: NumShifts;
set of int: S = 1..NumShifts;

array[S] of int: OfficersNeeded;
array[S] of int: ShiftCosts;

% Variables
array[S] of var int: Start;  % officers starting at shift s (work shifts s and s+1)
var int: TotalCost;

% Constraints
constraint forall(s in S)(Start[s] >= 0);

% Coverage: each shift must have enough officers working it
% Officers on shift s are those who started at s (cover s) and at s-1 (cover s).
% Wrap-around for s=1 uses starters at NumShifts (cover shift 1 as their second shift).
constraint forall(s in S)(
  Start[s] + Start[ if s = 1 then NumShifts else s-1 endif ] >= OfficersNeeded[s]
);

% Total cost
constraint TotalCost = sum(s in S)(ShiftCosts[s] * Start[s]);

% Objective
solve minimize TotalCost;