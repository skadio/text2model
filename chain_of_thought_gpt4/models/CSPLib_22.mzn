% Parameters
int: num_work;
int: num_shifts;
int: min_num_shifts;
set of int: WORK = 1..num_work;
set of int: SHIFTS = 1..num_shifts;
array[SHIFTS, WORK] of var 0..1: shifts;

% Variables
var 0..1: x[SHIFTS]; % Binary variable indicating whether a shift is selected or not

% Constraints
% Each work should be covered exactly once
constraint forall(w in WORK)(
  sum(s in SHIFTS)(shifts[s,w]*x[s]) = 1
);

% The number of shifts used should be at least the minimum number of shifts required
constraint sum(s in SHIFTS)(x[s]) >= min_num_shifts;

% Objective
% Minimize the number of shifts used
solve minimize sum(s in SHIFTS)(x[s]);