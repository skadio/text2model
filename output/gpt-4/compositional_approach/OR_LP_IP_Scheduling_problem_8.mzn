% Parameters
int: n; % Number of days in the recurring period
array[1..n] of int: demand; % Number of required employees per day
int: full_time_pay; % Pay per day of full time employee
int: part_time_pay; % Pay per day of part time employee
int: full_time_shift; % Number of consecutive days a full time employee works for
int: part_time_shift; % Number of consecutive days a part time employee works for

% Variables
array[1..n] of var 0..n: full_time_workers; % Number of full time workers required each day
array[1..n] of var 0..n: part_time_workers; % Number of part time workers required each day

% Constraints

% Constraint to ensure that the total number of workers (full time and part time) meet the demand for each day
constraint forall(i in 1..n) (
    full_time_workers[i] + part_time_workers[i] >= demand[i]
);

% Constraint to ensure that full time workers work for a consecutive number of days equal to their shift length
constraint forall(i in 1..n) (
    if i <= n - full_time_shift + 1 then
        sum(j in i..i+full_time_shift-1) (full_time_workers[j]) >= full_time_shift * full_time_workers[i]
    else
        sum(j in i..n) (full_time_workers[j]) + sum(j in 1..full_time_shift-(n-i+1)) (full_time_workers[j]) >= full_time_shift * full_time_workers[i]
    endif
);

% Constraint to ensure that part time workers work for a consecutive number of days equal to their shift length
constraint forall(i in 1..n) (
    if i <= n - part_time_shift + 1 then
        sum(j in i..i+part_time_shift-1) (part_time_workers[j]) >= part_time_shift * part_time_workers[i]
    else
        sum(j in i..n) (part_time_workers[j]) + sum(j in 1..part_time_shift-(n-i+1)) (part_time_workers[j]) >= part_time_shift * part_time_workers[i]
    endif
);

% Objective
solve minimize sum(i in 1..n) (full_time_workers[i]*full_time_pay + part_time_workers[i]*part_time_pay);