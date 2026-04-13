% Parameters
int: N;
array[1..N] of int: Num;
int: WorkingDays;
int: RestingDays;

int: Cycle = WorkingDays + RestingDays;

% Variables
array[1..N] of var 0..sum(Num): Start;     % employees whose work block starts on day d
var 0..sum(Num): TotalEmployees;

% Constraints
constraint WorkingDays >= 1;
constraint RestingDays >= 0;
constraint N >= 1;
constraint forall(d in 1..N)(Num[d] >= 0);

constraint TotalEmployees = sum(d in 1..N)(Start[d]);

constraint
  forall(t in 1..N)(
    sum(d in 1..N)(
      Start[d] * bool2int( ((t - d + N) mod N) < WorkingDays )
    ) >= Num[t]
  );

% Objective
solve minimize TotalEmployees;