% Parameters
int: N; % Number of days in recurring period
array[1..N] of int: Num; % The number of users on the nth day
int: WorkingDays; % Number of consecutive working days before a resting period
int: RestingDays; % Number of consecutive resting days

% Variables
array[1..N] of var 0..max(Num): Employees; % Number of employees working on each day

% Constraints
constraint forall(i in 1..N)(
  sum(j in max(1, i - WorkingDays + 1)..i)(Employees[j]) >= Num[i]
);

constraint forall(i in 1..N)(
  if i > WorkingDays then
    Employees[i] = Employees[i - WorkingDays]
  else
    true
  endif
);

% Objective
var int: TotalEmployees = sum(Employees);
solve minimize TotalEmployees;