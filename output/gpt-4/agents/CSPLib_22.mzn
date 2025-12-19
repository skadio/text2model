% Parameters
int: num_work; % Number of pieces of work to cover
int: num_shifts; % Number of possible shifts available
int: min_num_shifts; % Minimum number of shifts required for a partition
array[1..num_shifts] of set of 1..num_work: shifts; % Details of shifts each shift covers

% Variables
array[1..num_shifts] of var 0..1: shift_used; % Binary variable indicating whether a shift is used or not

% Constraints

% Each piece of work must be covered by exactly one shift
constraint forall(w in 1..num_work)(
  sum(s in 1..num_shifts)(shift_used[s] * bool2int(w in shifts[s])) = 1
);

% The number of shifts used must be at least the minimum number of shifts required
constraint sum(s in 1..num_shifts)(shift_used[s]) >= min_num_shifts;

% Objective
solve minimize sum(s in 1..num_shifts)(shift_used[s]);