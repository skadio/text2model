% Parameters
int: num_work;                 % Number of pieces of work that must be covered
int: num_shifts;               % Number of available candidate shifts
int: min_num_shifts;           % Minimum number of shifts required in a feasible partition

set of int: WORKS = 1..num_work;      % Index set for works
set of int: SHIFTS = 1..num_shifts;   % Index set for shifts

array[SHIFTS] of set of WORKS: shifts;  % shifts[s] = set of works covered by shift s (from .dzn)

% Variables
array[SHIFTS] of var 0..1: use_shift;   % 1 if shift s is selected, 0 otherwise

var min_num_shifts..num_shifts: total_shifts_used;  % Total number of selected shifts

% Constraints
% Link total_shifts_used to the chosen shifts
constraint
  total_shifts_used = sum(s in SHIFTS)(use_shift[s]);

% Enforce minimum number of shifts selected (redundant with var lower bound, but explicit)
constraint
  total_shifts_used >= min_num_shifts;

% Exact cover: each piece of work must be covered by exactly one selected shift
constraint
  forall(w in WORKS) (
    sum(s in SHIFTS where w in shifts[s]) (use_shift[s]) = 1
  );

% Objective
solve minimize total_shifts_used;