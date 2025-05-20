include "globals.mzn";

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
  if i > N - RestingDays + 1 then
    sum(j in i..N)(Employees[j]) <= sum(j in 1..(i + RestingDays - 1) mod N)(Employees[j])
  else
    sum(j in i..(i + RestingDays - 1))(Employees[j]) <= sum(j in max(1, i - WorkingDays + 1)..i)(Employees[j])
  endif
);

% Objective
var int: TotalEmployees = sum(Employees);
solve minimize TotalEmployees;

% Output
output ["Total number of employees to hire: ", show(TotalEmployees), "\n"] ++
["Employees on each day: "] ++ [show(Employees[i]) | i in 1..N];