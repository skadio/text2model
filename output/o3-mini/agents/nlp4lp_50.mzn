include "globals.mzn";

% Parameters (data)
int: NumShifts;
array[1..NumShifts] of int: OfficersNeeded;
array[1..NumShifts] of int: ShiftCosts;

% A safe upper bound for officers starting in any shift.
int: maxNeeded = sum(OfficersNeeded);

% Decision variables:
% start[s] is the number of officers scheduled to start at shift s.
array[1..NumShifts] of var 0..maxNeeded: start;

% Coverage constraints:
% For shift 1, only officers starting at shift 1 cover it.
constraint start[1] >= OfficersNeeded[1];
% For each subsequent shift s (2 .. NumShifts) the sum of officers
% that started in the previous shift and in this shift must cover the need.
constraint forall(s in 2..NumShifts)( start[s-1] + start[s] >= OfficersNeeded[s] );

% Objective: Minimize the total cost of starting officers.
var int: totalCost = sum(s in 1..NumShifts)( ShiftCosts[s] * start[s] );

solve minimize totalCost;

output [
  "Officers starting at each shift: ", show(start), "\n",
  "Total cost: ", show(totalCost)
];