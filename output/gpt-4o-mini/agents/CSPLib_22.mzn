int: num_work;                     % Number of pieces of work to cover
int: num_shifts;                   % Number of possible shifts available
int: min_num_shifts;               % Minimum number of shifts required for a partition
array[1..num_shifts] of set of int: shifts; % Details of shifts each shift covers

/* Variables */
array[1..num_shifts] of var 0..1: use_shift; % 1 if shift is used, 0 otherwise

/* Constraints */
% Ensure that each piece of work is covered exactly once
array[1..num_work] of var 0..num_shifts: work_covered;
constraint forall(w in 1..num_work)(
    work_covered[w] = sum(i in 1..num_shifts)(if w in shifts[i] then use_shift[i] else 0 endif)
);

% Each work must be covered exactly once
constraint forall(w in 1..num_work)(work_covered[w] = 1);

/* Ensure the minimum number of shifts is used */
constraint sum(i in 1..num_shifts)(use_shift[i]) >= min_num_shifts;

/* Objective: Minimize the number of shifts used */
var 0..num_shifts: total_shifts_used = sum(i in 1..num_shifts)(use_shift[i]);
solve minimize total_shifts_used;

/* Output */
output [ "Total shifts used = ", show(total_shifts_used), "\n", 
         "Shifts used = ", show([i | i in 1..num_shifts where use_shift[i] == 1]), "\n" ];