% Parameters
int: num_work;
int: num_shifts;
int: min_num_shifts;
array[1..num_shifts] of set of 1..num_work: shifts;

% Variables
array[1..num_shifts] of var 0..1: use_shift;

% Constraints
constraint
  forall(w in 1..num_work) (
    sum(s in 1..num_shifts)(bool2int(w in shifts[s]) * use_shift[s]) = 1
  );

constraint
  sum(s in 1..num_shifts)(use_shift[s]) >= min_num_shifts;

% Objective
solve minimize sum(s in 1..num_shifts)(use_shift[s]);