% Parameters
int: nShifts = 6;                         % Number of 4-hour time periods in the day
set of int: SHIFTS = 1..nShifts;          % Index set for time periods

array[SHIFTS] of int: required =          % Required drivers/crew in each time period
  [60, 70, 60, 50, 20, 30];

int: shiftLengthPeriods = 2;              % 8 hours = 2 consecutive 4-hour periods covered by one start

% Coverage mapping: a worker starting in period s covers period s and the next period (cyclic over 6)
array[SHIFTS, SHIFTS] of int: covers =
  array2d(SHIFTS, SHIFTS,
    [
      1,1,0,0,0,0,   % start 1 covers 1,2
      0,1,1,0,0,0,   % start 2 covers 2,3
      0,0,1,1,0,0,   % start 3 covers 3,4
      0,0,0,1,1,0,   % start 4 covers 4,5
      0,0,0,0,1,1,   % start 5 covers 5,6
      1,0,0,0,0,1    % start 6 covers 6,1 (wrap-around)
    ]
  );

int: maxRequired = max(required);         % Upper bound helper for decision variables
int: maxTotalStaff = sum(required);       % Safe global upper bound

% Variables
array[SHIFTS] of var 0..maxTotalStaff: startStaff;  % Number starting at beginning of each period
var 0..maxTotalStaff: totalStaff;                   % Total number of staff employed (minimize)

% Constraints
% Link totalStaff to the number of staff starting in each period
constraint totalStaff = sum(s in SHIFTS)(startStaff[s]);

% Coverage constraints: each time period must have enough staff working.
% Staff working in period p are those who started in any period s that covers p.
constraint
  forall(p in SHIFTS) (
    sum(s in SHIFTS)(startStaff[s] * covers[s, p]) >= required[p]
  );

% (Optional redundant strengthening) Total staff must be at least the peak requirement
constraint totalStaff >= maxRequired;

% Objective
solve minimize totalStaff;