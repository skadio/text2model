% Parameters
% There are 6 time periods (each 4 hours) covering a full 24-hour day.
int: nPeriods = 6;
set of int: PERIODS = 1..nPeriods;

% Minimum number of waiters needed in each 4-hour period:
% 1:  2~6   -> 4
% 2:  6~10  -> 8
% 3: 10~14  -> 10
% 4: 14~18  -> 7
% 5: 18~22  -> 12
% 6: 22~2   -> 4
array[PERIODS] of int: minNeeded = [4, 8, 10, 7, 12, 4];

% Each waiter works 8 hours continuously = 2 consecutive 4-hour periods.
int: shiftLengthPeriods = 2; % (kept for clarity; coverage below uses 2 periods)

% Set of possible shift start periods (one shift can start at each period).
set of int: STARTS = PERIODS;

% Coverage matrix: cover[s,p] = 1 if a waiter starting at s works during period p (cyclic wrap-around).
% Since a shift lasts 2 consecutive periods, it covers period s and the next period (with wrap-around).
array[STARTS, PERIODS] of int: cover =
  array2d(STARTS, PERIODS,
    [ if (p == s) \/ (p == ((s mod nPeriods) + 1)) then 1 else 0 endif
      | s in STARTS, p in PERIODS ]);

% Variables
% x[s] = number of waiters whose 8-hour shift starts at period s.
array[STARTS] of var 0..sum(minNeeded): x;

% Total number of waiters employed.
var 0..sum(minNeeded): totalWaiters;

% Constraints
% --- Staffing coverage constraints (meet minimum demand in each period) ---
constraint
  forall(p in PERIODS) (
    sum(s in STARTS) (x[s] * cover[s,p]) >= minNeeded[p]
  );

% --- Total waiters definition constraint (link totalWaiters to shift starts) ---
constraint
  totalWaiters = sum(s in STARTS) (x[s]);

% Objective
solve minimize totalWaiters;