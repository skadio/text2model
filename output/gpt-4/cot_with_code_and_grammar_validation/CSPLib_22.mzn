% Parameters
int: num_work;
int: num_shifts;
int: min_num_shifts;
array[1..num_shifts] of set of 1..num_work: shifts;

% Variables
array[1..num_shifts] of var 0..1: x; % Binary variable indicating whether a shift is selected or not

% Constraints
% Each piece of work must be covered exactly once
constraint forall(i in 1..num_work)(
  sum(j in 1..num_shifts)(x[j]*(card({i} intersect shifts[j]))) = 1
);

% The number of shifts used must be at least the minimum number of shifts required
constraint sum(i in 1..num_shifts)(x[i]) >= min_num_shifts;

% Objective
% Minimize the number of shifts used
solve minimize sum(i in 1..num_shifts)(x[i]);