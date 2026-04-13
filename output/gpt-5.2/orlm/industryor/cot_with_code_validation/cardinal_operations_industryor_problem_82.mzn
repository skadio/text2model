% Parameters
int: H = 24;                 % hours in a day
int: shiftLen = 8;           % each waiter works 8 consecutive hours
set of int: HOURS = 0..H-1;  % represent hours as 0..23

% Minimum required waiters for each hour (0..23), embedded data
array[HOURS] of int: req = array1d(HOURS,
  [ 4,4,4,4,          % 0..3   (22~2)
    4,4,             % 4..5   (2~6)
    8,8,8,8,         % 6..9   (6~10)
    10,10,10,10,     % 10..13 (10~14)
    7,7,7,7,         % 14..17 (14~18)
    12,12,12,12,     % 18..21 (18~22)
    4,4              % 22..23 (22~2)
  ]
);

% Variables
array[HOURS] of var 0..sum(req): x;   % x[h] = #waiters starting at hour h
var 0..sum(req): totalWaiters;

% Constraints
constraint totalWaiters = sum(h in HOURS)(x[h]);

% Coverage: for each hour t, sum of starts in the previous 8 hours (wrapping) covers demand
constraint
  forall(t in HOURS) (
    sum(k in 0..shiftLen-1)( x[(t - k + H) mod H] ) >= req[t]
  );

% Objective
solve minimize totalWaiters;