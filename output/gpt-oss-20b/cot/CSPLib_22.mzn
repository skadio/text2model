% Parameters
int: num_work;
int: num_shifts;
int: min_num_shifts;
array[1..num_shifts] of set of 1..num_work: shifts;

% Variables
array[1..num_shifts] of var 0..1: x;

% Constraints
constraint
  forall(j in 1..num_work) (
    sum([x[i] | i in 1..num_shifts where j in shifts[i]]) == 1
  );

constraint
  sum(x) >= min_num_shifts;

% Objective
solve minimize sum(x);