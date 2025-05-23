% Parameters
int: num_work;
int: num_shifts;
int: min_num_shifts;
array[1..num_shifts] of set of int: shifts;   % each shift’s covered works (indices in 1..num_work)

% Variables
array[1..num_shifts] of var 0..1: useShift;   % 1 if shift is selected

% Constraints
constraint
   forall(w in 1..num_work)(
      sum(s in 1..num_shifts where w in shifts[s])(useShift[s]) = 1
   );

constraint
   sum(s in 1..num_shifts)(useShift[s]) >= min_num_shifts;

% Objective
solve minimize sum(s in 1..num_shifts)(useShift[s]);