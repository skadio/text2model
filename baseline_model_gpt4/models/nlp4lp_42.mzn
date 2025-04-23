% Input parameters
int: N; % Number of days in recurring period
array[1..N] of int: Num; % The number of users on the nth day
int: WorkingDays; % Number of consecutive working days before a resting period
int: RestingDays; % Number of consecutive resting days

% Decision variable
var int: employees; % The number of employees to hire

% Auxiliary variables
array[1..N] of var 0..N: staff; % The number of staff working on each day

% Constraints
constraint forall(i in 1..N) (
  staff[i] = sum(j in max(1, i - WorkingDays + 1)..i) (if j mod (WorkingDays + RestingDays) <= WorkingDays then employees else 0 endif)
);

constraint forall(i in 1..N) (
  staff[i] >= Num[i]
);

% Objective
solve minimize employees;

% Output
output ["Minimum number of employees to hire: ", show(employees)];