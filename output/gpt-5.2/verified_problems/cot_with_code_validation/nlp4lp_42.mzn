% Parameters (provided in .dzn)
int: N;
array[1..N] of int: Num;
int: WorkingDays;
int: RestingDays;

% Derived
int: Cycle = WorkingDays + RestingDays;

% Basic validity
constraint N > 0;
constraint WorkingDays >= 0;
constraint RestingDays >= 0;
constraint forall(d in 1..N)(Num[d] >= 0);
constraint Cycle > 0;

% Variables
int: UB = sum(Num);
array[1..N] of var 0..UB: Start;          % employees whose work block starts on day d (recurring)
var 0..UB: TotalEmployees;

% Total employees
constraint TotalEmployees = sum(d in 1..N)(Start[d]);

% Coverage constraints: employees starting at s work on day 'day' if within WorkingDays days of start (mod N)
constraint
  forall(day in 1..N)(
    sum(s in 1..N)(
      Start[s] * bool2int(((day - s + N) mod N) < WorkingDays)
    ) >= Num[day]
  );

solve minimize TotalEmployees;

output [
  "TotalEmployees = ", show(TotalEmployees), "\n",
  "Start = ", show(Start), "\n"
];