% Parameters
int: N;                              % Number of days in the recurring period
set of int: DAYS = 1..N;             % Day indices

array[DAYS] of int: Num;             % Required employees on each day (demand)
int: WorkingDays;                    % Consecutive working days
int: RestingDays;                    % Consecutive resting days

int: CycleLen = WorkingDays + RestingDays;  % Total length of one work/rest cycle (for clarity)

% Variables
array[DAYS] of var int: startOn;     % startOn[d] = employees whose cycle starts (first working day) on day d
var int: totalEmployees;             % Total number of employees to hire (minimize)

% Constraints

% --- Basic domain restrictions (non-negativity) ---
constraint forall(d in DAYS) (startOn[d] >= 0);
constraint totalEmployees >= 0;

% --- Link totalEmployees to the number of started cycles over the recurring period ---
% Each employee corresponds to exactly one start day in the recurring schedule.
constraint totalEmployees = sum(d in DAYS)(startOn[d]);

% --- Coverage constraints: daily staffing must meet demand ---
% An employee starting on day s works for WorkingDays consecutive days.
% Day arithmetic is modulo N due to the recurring period.
constraint
  forall(d in DAYS) (
    sum(s in DAYS) (
      startOn[s] * bool2int( ((d - s + N) mod N) < WorkingDays )
    ) >= Num[d]
  );

% Objective
solve minimize totalEmployees;