include "globals.mzn";

% --------------------
% Input data
% --------------------
int: NumShifts;
set of int: S = 1..NumShifts;

array[S] of int: OfficersNeeded;  % required officers working in shift s
array[S] of int: ShiftCosts;      % cost per officer starting at shift s

% --------------------
% Decision variables
% --------------------
% start[s] = number of officers whose 2-shift duty starts at shift s
array[S] of var 0..max(OfficersNeeded): start;

% --------------------
% Constraints
% --------------------
% Each shift s must have enough officers working.
% Officers working in shift s are those who started at s (cover s and s+1)
% plus those who started at s-1 (cover s-1 and s).
%
% Wrap-around is assumed: shift NumShifts is consecutive with shift 1.
constraint forall(s in S)(
  start[s] + start[ if s = 1 then NumShifts else s - 1 endif ] >= OfficersNeeded[s]
);

% --------------------
% Objective
% --------------------
var int: TotalCost = sum(s in S)(ShiftCosts[s] * start[s]);

solve minimize TotalCost;

% --------------------
% Output
% --------------------
output [
  "StartOfficersPerShift = ", show(start), "\n",
  "TotalCost = ", show(TotalCost), "\n"
];