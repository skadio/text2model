% Parameters
int: num_work;                 % Number of pieces of work to cover
int: num_shifts;               % Number of possible shifts available
int: min_num_shifts;           % Minimum number of shifts required

set of int: WORKS = 1..num_work;
set of int: SHIFTS = 1..num_shifts;

% The data may contain 0 in shift-work lists (e.g., as padding). Allow 0 here,
% and ignore it in coverage constraints.
set of int: WORKS0 = 0..num_work;

array[SHIFTS] of set of WORKS0: shifts;  % shifts[s] = set of works (and possibly 0) covered by shift s


% Variables
array[SHIFTS] of var 0..1: use_shift;                 % 1 if shift s is selected, else 0
var min_num_shifts..num_shifts: total_shifts_used;    % total number of selected shifts


% Constraints

% Link total_shifts_used to selected shifts
constraint
  total_shifts_used = sum(s in SHIFTS)(use_shift[s]);

% Enforce minimum number of shifts selected
constraint
  total_shifts_used >= min_num_shifts;

% Exact cover: each work must be covered by exactly one selected shift
constraint
  forall(w in WORKS)(
    sum(s in SHIFTS where w in shifts[s])(use_shift[s]) = 1
  );


% Objective
solve minimize total_shifts_used;