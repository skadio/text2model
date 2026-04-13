% Bus driver scheduling as a set partitioning problem

% Parameters
int: num_work;
int: num_shifts;
int: min_num_shifts;
array[1..num_shifts] of set of int: shifts;

% Decision variables
array[1..num_shifts] of var bool: use_shift;

% Basic validity (optional but safe): all covered work indices are within range
constraint
  forall(s in 1..num_shifts, w in shifts[s]) (
    1 <= w /\ w <= num_work
  );

% Each piece of work must be covered exactly once
constraint
  forall(w in 1..num_work) (
    sum(s in 1..num_shifts where w in shifts[s]) (bool2int(use_shift[s])) = 1
  );

% Minimum number of shifts required
constraint
  sum(s in 1..num_shifts) (bool2int(use_shift[s])) >= min_num_shifts;

% Objective: minimize number of shifts used
solve minimize sum(s in 1..num_shifts) (bool2int(use_shift[s]));