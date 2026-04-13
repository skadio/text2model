% Parameters
int: nShifts = 6;                          % Number of 4-hour periods in the 24-hour cycle
set of int: SHIFTS = 1..nShifts;           % Index set for time periods / possible start times

array[SHIFTS] of int: required =           % Required drivers/crew during each 4-hour period
  [60, 70, 60, 50, 20, 30];

int: maxStaff = sum(i in SHIFTS)(required[i]);   % Safe upper bound on starters (sum of requirements)

% Variables
array[SHIFTS] of var 0..maxStaff: startStaff;    % Number starting work at beginning of each period (work 8 hours)
var 0..(nShifts * maxStaff): totalStaff;         % Total number of staff used (sum of starters)

% Constraints

% Link totalStaff to the number of staff starting in each 4-hour period
constraint totalStaff = sum(s in SHIFTS)(startStaff[s]);

% Coverage constraints: staff work 8 hours = 2 consecutive 4-hour periods.
% Demand in period p is covered by those starting in p and in the previous period (cyclic over 24h).
constraint
  forall(p in SHIFTS) (
    startStaff[p] + startStaff[ if p = 1 then nShifts else p - 1 endif ] >= required[p]
  );

% Objective
solve minimize totalStaff;