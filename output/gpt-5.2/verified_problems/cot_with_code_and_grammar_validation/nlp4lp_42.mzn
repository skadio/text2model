% Parameters
int: N;
array[1..N] of int: Num;
int: WorkingDays;
int: RestingDays;

% Variables
int: Cycle = WorkingDays + RestingDays;
int: MaxDemand = max(Num);

array[1..N] of var 0..MaxDemand: Start;  % employees whose work block starts on day d
var 0..N*MaxDemand: TotalEmployees;

% Constraints
constraint N > 0;
constraint WorkingDays > 0;
constraint RestingDays >= 0;
constraint forall(d in 1..N)(Num[d] >= 0);

constraint TotalEmployees = sum(d in 1..N)(Start[d]);

% Coverage constraints (recurring schedule)
constraint
  forall(day in 1..N)(
    sum(s in 1..N where ((day - s + N) mod N) < WorkingDays)(Start[s]) >= Num[day]
  );

% Objective
solve minimize TotalEmployees;