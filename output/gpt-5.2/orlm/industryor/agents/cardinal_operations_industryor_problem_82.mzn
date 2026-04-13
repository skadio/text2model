% Parameters
% Time periods (6 consecutive 4-hour blocks covering 24 hours)
int: nPeriods = 6;
set of int: PERIODS = 1..nPeriods;

% Minimum waiters required in each 4-hour period:
% 1: [2,6), 2: [6,10), 3: [10,14), 4: [14,18), 5: [18,22), 6: [22,2)
array[PERIODS] of int: minNeed = [4, 8, 10, 7, 12, 4];

% Shifts (each shift is 8 hours = 2 consecutive periods), starting at the period boundaries:
% 1 starts at 2:00, 2 at 6:00, 3 at 10:00, 4 at 14:00, 5 at 18:00, 6 at 22:00
int: nShifts = 6;
set of int: SHIFTS = 1..nShifts;

% Coverage matrix: cover[p,s] = 1 if shift s covers period p, else 0
% Shift s covers period s and the next period (with wrap-around)
array[PERIODS, SHIFTS] of int: cover =
[
% s=1 2 3 4 5 6
   1,0,0,0,0,1,  % p=1 (2-6): covered by shifts 1 and 6 (22-6)
   1,1,0,0,0,0,  % p=2 (6-10): shifts 1 and 2
   0,1,1,0,0,0,  % p=3 (10-14): shifts 2 and 3
   0,0,1,1,0,0,  % p=4 (14-18): shifts 3 and 4
   0,0,0,1,1,0,  % p=5 (18-22): shifts 4 and 5
   0,0,0,0,1,1   % p=6 (22-2): shifts 5 and 6
];

% A safe upper bound for number of waiters starting any shift
int: maxNeed = max(p in PERIODS)(minNeed[p]);

% Variables
% x[s] = number of waiters who start shift s (and work 8 hours = 2 periods)
array[SHIFTS] of var 0..maxNeed: x;

% total waiters employed
var 0..(nShifts * maxNeed): totalWaiters;

% Constraints
% Link total number of waiters to the number starting each shift
constraint
  totalWaiters = sum(s in SHIFTS)(x[s]);

% Coverage constraints: each period must have at least the required number of waiters
constraint
  forall(p in PERIODS) (
    sum(s in SHIFTS)(cover[p, s] * x[s]) >= minNeed[p]
  );

% Objective
solve minimize totalWaiters;