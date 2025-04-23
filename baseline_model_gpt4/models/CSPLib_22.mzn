% Input parameters
int: num_work;
int: num_shifts;
int: min_num_shifts;
set of int: WORK = 1..num_work;
set of int: SHIFTS = 1..num_shifts;
array[SHIFTS] of set of WORK: shifts;

% Decision variable
array[SHIFTS] of var 0..1: x; % x[i] is 1 if shift i is used, 0 otherwise

% Objective: Minimize the number of shifts used
minimize sum(i in SHIFTS)(x[i]);

% Constraints
% Each piece of work must be covered exactly once
constraint forall(w in WORK)(sum(i in SHIFTS | w in shifts[i])(x[i]) = 1);

% The number of shifts used must be at least the minimum number of shifts required
constraint sum(i in SHIFTS)(x[i]) >= min_num_shifts;

% Solve
solve satisfy;