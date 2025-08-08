include "globals.mzn";

/* --- data ----------------------------------------------------- */
int: NumShifts;                     % number of shifts
array[1..NumShifts] of int: OfficersNeeded;   % required officers per shift
array[1..NumShifts] of int: ShiftCosts;       % cost of starting an officer at a shift

/* --- decision variables --------------------------------------- */
int: maxStart = sum(s in 1..NumShifts)(OfficersNeeded[s]);   % upper bound for starts
array[1..NumShifts] of var 0..maxStart: start;      % officers that start at shift s
array[1..NumShifts] of var 0..maxStart: cover;      % officers on duty at shift s

/* --- constraints ---------------------------------------------- */
% no officer can start after the last shift (otherwise it would cover a
% nonexistent shift and only increase the cost)
constraint start[NumShifts] = 0;

% coverage relation: an officer that starts at shift s works also shift s+1
constraint forall(s in 1..NumShifts) (
    cover[s] = start[s] + (if s > 1 then start[s-1] else 0)
);

% each shift must be staffed with at least the required number of officers
constraint forall(s in 1..NumShifts) (
    cover[s] >= OfficersNeeded[s]
);

var int: totalCost;
constraint totalCost = sum(s in 1..NumShifts) (start[s] * ShiftCosts[s]);

/* --- objective ------------------------------------------------ */
solve minimize totalCost;

/* --- output ---------------------------------------------------- */
output [
    "Start assignments (officers starting each shift): ", show(start), "\n",
    "Coverage per shift (officers on duty): ", show(cover), "\n",
    "Total cost: ", show(totalCost), "\n"
];