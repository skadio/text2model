% Parameters
int: num_work;                             % Number of distinct pieces of work
int: num_shifts;                           % Number of available shifts
int: min_num_shifts;                       % Lower bound on the number of shifts to be used
array[1..num_shifts] of set of int: shifts;% Works covered by each shift (indices in 1..num_work)

% Variables
array[1..num_shifts] of var 0..1: x;       % 1 if shift s is selected, 0 otherwise

% Constraints
constraint
    sum(s in 1..num_shifts)(x[s]) >= min_num_shifts;    % Respect the minimum number of shifts;

constraint
    forall(w in 1..num_work)(
        sum(s in 1..num_shifts)( x[s] * bool2int(w in shifts[s]) ) == 1
    );                                                  % Each work covered exactly once

% Objective
solve minimize sum(s in 1..num_shifts)(x[s]);           % Minimize the total number of shifts