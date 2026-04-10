% Police shift scheduling (each officer works 2 consecutive shifts with wrap-around)

% Parameters
int: NumShifts;
set of int: SHIFTS = 1..NumShifts;

array[SHIFTS] of int: OfficersNeeded;
array[SHIFTS] of int: ShiftCosts;

% Variables
array[SHIFTS] of var 0..sum(OfficersNeeded) : Start; % officers starting at shift s
var int: TotalCost;

% Constraints
% Coverage: shift s is covered by officers who start at s and those who started at previous shift (wrap-around)
constraint forall(s in SHIFTS) (
  Start[s] + Start[ if s = 1 then NumShifts else s - 1 endif ] >= OfficersNeeded[s]
);

% Total cost
constraint TotalCost = sum(s in SHIFTS)(ShiftCosts[s] * Start[s]);

% Objective
solve minimize TotalCost;

output [
  "TotalCost = ", show(TotalCost), "\n",
  "Start = ", show(Start), "\n"
];