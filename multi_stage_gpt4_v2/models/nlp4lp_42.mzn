% Parameters
int: N; % Number of days in recurring period
array[1..N] of int: Num; % The number of users on the nth day
int: WorkingDays; % Number of consecutive working days before a resting period
int: RestingDays; % Number of consecutive resting days

% Variables
var 0..sum(Num): totalEmployees; % Total number of employees to hire
array[1..N] of var 0..max(Num): employeesOnDay; % Number of employees working on each day

% Constraints

% Each day must have enough employees to cover the required number of users
constraint forall(i in 1..N) (
    employeesOnDay[i] >= Num[i]
);

% The total number of employees is the sum of employees working on any day
constraint totalEmployees = sum(employeesOnDay);

% The number of employees working on a day is the sum of the employees starting their work in the previous WorkingDays days
constraint forall(i in 1..N) (
    employeesOnDay[i] = sum(j in max(1, i - WorkingDays + 1)..i) (
        if j <= 0 then
            employeesOnDay[j + N]
        else
            employeesOnDay[j]
        endif
    )
);

% The number of employees starting their work on a day is the same as the number of employees ending their work on the day WorkingDays + RestingDays ago
constraint forall(i in 1..N) (
    if i <= WorkingDays then
        employeesOnDay[i] = employeesOnDay[i + WorkingDays + RestingDays]
    else
        employeesOnDay[i] = employeesOnDay[i - WorkingDays]
    endif
);

% Objective
solve minimize totalEmployees;