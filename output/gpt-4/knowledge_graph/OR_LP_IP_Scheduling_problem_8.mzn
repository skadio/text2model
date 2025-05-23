include "globals.mzn";

% Parameters
int: n; % Number of days in the recurring period
array[0..n-1] of int: demand; % Number of required employees per day
int: full_time_pay; % Pay per day of full time employee
int: part_time_pay; % Pay per day of part time employee
int: full_time_shift; % Number of consecutive days a full time employee works for
int: part_time_shift; % Number of consecutive days a part time employee works for

% Variables
array[0..n-1] of var 0..n: full_time_workers; % Number of full time workers per day
array[0..n-1] of var 0..n: part_time_workers; % Number of part time workers per day

% Constraints
constraint forall(i in 0..n-1) (
  full_time_workers[i] + part_time_workers[i] >= demand[i]
);

constraint forall(i in 0..n-1) (
  sum(j in max(0, i-full_time_shift+1)..i) (full_time_workers[j]) <= full_time_shift
);

constraint forall(i in 0..n-1) (
  sum(j in max(0, i-part_time_shift+1)..i) (part_time_workers[j]) <= part_time_shift
);

% Objective
var int: total_cost = sum(i in 0..n-1) (full_time_workers[i]*full_time_pay + part_time_workers[i]*part_time_pay);
solve minimize total_cost;

% Output
output ["Total cost: ", show(total_cost), "\n",
        "Full time workers: ", show(full_time_workers), "\n",
        "Part time workers: ", show(part_time_workers)];