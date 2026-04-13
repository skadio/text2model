% Parameters
int: num_work;
int: num_shifts;
int: min_num_shifts;

% shifts[s] is the set of works covered by shift s (works are in 1..num_work)
array[1..num_shifts] of set of int: shifts;

% Variables
array[1..num_shifts] of var 0..1: use_shift;

% Constraints
constraint forall(s in 1..num_shifts)(
  shifts[s] subset 1..num_work
);

constraint forall(w in 1..num_work)(
  sum(s in 1..num_shifts where w in shifts[s])(use_shift[s]) = 1
);

constraint sum(s in 1..num_shifts)(use_shift[s]) >= min_num_shifts;

% Objective
solve minimize sum(s in 1..num_shifts)(use_shift[s]);