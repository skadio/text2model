int: N;
array[1..N] of int: Num;
int: WorkingDays;
int: RestingDays;

int: Cycle = WorkingDays + RestingDays;

set of int: Days = 1..N;
set of int: Starts = 1..Cycle;

array[Starts] of var int: startEmployees; % employees whose cycle starts at position s (1..Cycle)
var int: Employees = sum(s in Starts)(startEmployees[s]);

constraint forall(s in Starts)(startEmployees[s] >= 0);

function bool: works_on(int: s, int: d) =
  (((d - s) mod Cycle + Cycle) mod Cycle) < WorkingDays;

constraint forall(d in Days)(
  sum(s in Starts)(bool2int(works_on(s,d)) * startEmployees[s]) >= Num[d]
);

solve minimize Employees;

output [
  "Employees = ", show(Employees), ";\n",
  "startEmployees = ", show(startEmployees), ";\n"
];