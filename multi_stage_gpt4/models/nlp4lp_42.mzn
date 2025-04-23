% Parameters
int: N; % Number of days in recurring period
array[1..N] of int: Num; % The number of users on the nth day
int: WorkingDays; % Number of consecutive working days before a resting period
int: RestingDays; % Number of consecutive resting days

% Variables
array[1..N] of var int: Employees; % Number of employees required on each day
var int: TotalEmployees; % Total number of employees to hire

% Constraints

% Each employee works for 'WorkingDays' days and then rests for 'RestingDays' days
constraint forall(i in 1..N) (
  Employees[i] = sum(j in 0..(WorkingDays-1)) (
    if i-j > 0 then
      Employees[i-j]
    else
      Employees[N+i-j]
    endif
  )
);

% The total number of employees is the maximum number of employees required on any day
constraint TotalEmployees = max(Employees);

% The number of employees required on each day must be greater than or equal to the number of users on that day
constraint forall(i in 1..N) (
  Employees[i] >= Num[i]
);

% Objective
solve minimize TotalEmployees;