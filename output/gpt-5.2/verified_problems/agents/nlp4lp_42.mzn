% Parameters
int: N;                                % Number of days in the recurring period
set of int: DAYS = 1..N;               % Day indices

array[DAYS] of int: Num;               % Required employees on each day (demand)
int: WorkingDays;                      % Consecutive working days per employee
int: RestingDays;                      % Consecutive resting days per employee

int: CycleLength = WorkingDays + RestingDays;   % Length of one work/rest cycle

% Variables
% x[d] = number of employees whose work block starts on day d (works d..d+WorkingDays-1 cyclically)
array[DAYS] of var 0..sum(Num): x;

% Total number of employees hired
var 0..sum(Num): totalEmployees;

% Constraints
% --- Total employees hired equals the number of start-days across the cycle
constraint
  totalEmployees = sum(d in DAYS)(x[d]);

% --- Demand coverage on each day (cyclic schedule)
% Employees starting on day s work for WorkingDays consecutive days:
% they cover day d iff (d - s) mod CycleLength is in 0..WorkingDays-1.
constraint
  forall(d in DAYS) (
    sum(s in DAYS)(
      x[s] * bool2int( ((d - s) mod CycleLength) >= 0 /\ ((d - s) mod CycleLength) < WorkingDays )
    ) >= Num[d]
  );

% Objective
solve minimize totalEmployees;