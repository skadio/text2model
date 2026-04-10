% Parameters
int: N;
array[1..N] of int: Num;
int: WorkingDays;
int: RestingDays;

int: Cycle = WorkingDays + RestingDays;

% Variables
array[1..N] of var 0..sum(Num): Start;   % employees whose work block starts on day d (mod N)
var 0..sum(Num): TotalEmployees;

% Constraints
constraint WorkingDays >= 0;
constraint RestingDays >= 0;
constraint Cycle > 0;

constraint TotalEmployees = sum(d in 1..N)(Start[d]);

% Coverage: employees starting within the last WorkingDays days (cyclic) work on day t
constraint
  forall(t in 1..N) (
    sum(k in 0..WorkingDays-1)(
      Start[ ((t - k - 1 + N) mod N) + 1 ]
    ) >= Num[t]
  );

% Objective
solve minimize TotalEmployees;