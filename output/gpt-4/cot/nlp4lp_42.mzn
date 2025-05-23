% Parameters
int: N; % Number of days in recurring period
array[1..N] of int: Num; % The number of users on the nth day
int: WorkingDays; % Number of consecutive working days before a resting period
int: RestingDays; % Number of consecutive resting days

% Variables
var 0..sum(Num): totalEmployees; % Total number of employees
array[1..N] of var 0..totalEmployees: Employees; % Number of employees working on each day

% Constraints
constraint forall(i in 1..N)(
  sum(j in max(1, i - WorkingDays + 1)..i)(Employees[j]) >= Num[i]
);

constraint forall(i in WorkingDays+1..N)(
  Employees[i] = Employees[i - WorkingDays]
);

% Objective
solve minimize totalEmployees;