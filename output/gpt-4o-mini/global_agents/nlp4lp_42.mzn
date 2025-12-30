include "globals.mzn";

int: N;                          % Number of days in recurring period
array[1..N] of int: Num;        % Number of users needed on each day
int: WorkingDays;               % Number of consecutive working days
int: RestingDays;               % Number of consecutive resting days

int: total_days = WorkingDays + RestingDays; % Total cycle length

% Number of employees needed
var 0..N: num_employees;

% Array to represent the schedule of employees
array[1..num_employees] of var 0..1: schedule; % 1 = working, 0 = off

% Constraints to ensure that the number of employees meets the required staff
array[1..N] of var 0..num_employees: staff_needed;

% Each employee works for WorkingDays and then rests for RestingDays
constraint forall(d in 1..N) (
    staff_needed[d] = sum(i in 1..num_employees)(
        if (d - (i - 1) * total_days) > 0 then
            schedule[i] * (if (d mod total_days <= WorkingDays) then 1 else 0)
        else
            0
        endif
    )
);

% Ensure that the staff_needed meets the required number of users
constraint forall(d in 1..N) (
    staff_needed[d] >= Num[d]
);

% Objective: Minimize the number of employees
solve minimize num_employees;

% Output the results
output [ "Number of employees hired: ", show(num_employees), "\n" ];