% Parameters
int: nPeriods = 6;                            % Number of 4-hour time periods in the day
set of int: PERIODS = 1..nPeriods;            % Index set for time periods
set of int: STARTS  = 1..nPeriods;            % Index set for possible shift start times

array[PERIODS] of string: periodName =        % Labels for periods (optional, for clarity)
  ["02-06","06-10","10-14","14-18","18-22","22-02"];

array[PERIODS] of int: demand =               % Required salespeople per period
  [10, 15, 25, 20, 18, 12];

int: shiftLengthPeriods = 2;                  % 8 hours = 2 periods of 4 hours each

% cover[s,p] = 1 if a shift starting at s covers period p (current period and next, with wrap-around)
array[STARTS, PERIODS] of int: cover =
  array2d(STARTS, PERIODS,
    [ if (p = s) \/ (p = ((s mod nPeriods) + 1)) then 1 else 0 endif
      | s in STARTS, p in PERIODS
    ]);

int: maxStaff = sum(p in PERIODS)(demand[p]); % Safe upper bound on staff starting at any time

% Variables
array[STARTS] of var 0..maxStaff: startStaff; % Number of staff starting shift at each start time
var 0..(nPeriods*maxStaff): totalStaff;       % Total number of staff (objective)

% Constraints
% Demand coverage constraints:
% For each period p, the sum of staff whose shifts cover p must meet or exceed demand[p].
constraint
  forall(p in PERIODS) (
    sum(s in STARTS) (startStaff[s] * cover[s, p]) >= demand[p]
  );

% Total staff definition:
constraint
  totalStaff = sum(s in STARTS)(startStaff[s]);

% Objective
solve minimize totalStaff;