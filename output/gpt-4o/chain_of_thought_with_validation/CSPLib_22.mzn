% Parameters
int: num_work;
int: num_shifts;
int: min_num_shifts;
array[1..num_shifts] of set of 1..num_work: shifts;

% Variables
array[1..num_shifts] of var 0..1: x;      % x[s] = 1 ⇔ shift s is selected

% Constraints
constraint
    sum(s in 1..num_shifts)(x[s]) >= min_num_shifts;

constraint
    forall(w in 1..num_work)(
        sum(s in 1..num_shifts)(bool2int(w in shifts[s]) * x[s]) == 1
    );

% Objective
solve minimize sum(s in 1..num_shifts)(x[s]);