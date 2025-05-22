% Parameters
int: N;                                   % Number of days in the recurring period
array[1..N] of int: Num;                  % Required number of employees each day
int: WorkingDays;                         % Consecutive working days
int: RestingDays;                         % Consecutive resting days

% Derived constants
int: CycleLength = WorkingDays + RestingDays;
int: MaxEmployees = sum(d in 1..N)(Num[d]);   % Safe upper bound for employees

% Variables
array[1..N] of var 0..MaxEmployees: x;    % x[s] = employees whose cycle starts on day s (1-based)

% Constraints
constraint
  forall(d in 1..N)(
    sum(s in 1..N)(
      x[s] * bool2int( ((d - s + CycleLength) mod CycleLength) < WorkingDays )
    ) >= Num[d]
  );

% Objective
solve minimize sum(s in 1..N)(x[s]);