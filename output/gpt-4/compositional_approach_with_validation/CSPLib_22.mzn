% Parameters
int: num_work; % Number of pieces of work to cover
int: num_shifts; % Number of possible shifts available
int: min_num_shifts; % Minimum number of shifts required for a partition
array[1..num_shifts] of set of 1..num_work: shifts; % Details of shifts each shift covers

% Variables
array[1..num_shifts] of var 0..1: shift_used; % Binary variable indicating whether a shift is used or not

% Constraints

% Ensure that each piece of work is covered exactly once
constraint forall(i in 1..num_work)(
  sum(j in 1..num_shifts)(shift_used[j] * bool2int(i in shifts[j])) = 1
);

% Ensure that the number of shifts used is at least the minimum number of shifts required
constraint sum(shift_used) >= min_num_shifts;

% Ensure that the number of shifts used is less than or equal to the total number of shifts available
constraint sum(shift_used) <= num_shifts;

% Objective
solve minimize sum(shift_used);