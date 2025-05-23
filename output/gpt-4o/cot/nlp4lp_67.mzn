% Parameters
int: M;
int: N;
int: large_roll_width;
array[1..M] of int: demands;
array[1..M] of float: roll_width_options;
array[1..N, 1..M] of int: patterns;

% An explicit (loose) upper bound on the number of large rolls needed
int: max_large_rolls = sum(demands);

% Variables
array[1..N] of var 0..max_large_rolls: use_pattern;   % how many times pattern j is applied

% Constraints
%
% 1. Patterns must be physically feasible w.r.t. roll widths
constraint
    forall(j in 1..N) (
        sum(i in 1..M) (float(patterns[j,i]) * roll_width_options[i])
        <= float(large_roll_width)
    );

% 2. Demand satisfaction for each small-roll type
constraint
    forall(i in 1..M) (
        sum(j in 1..N) (patterns[j,i] * use_pattern[j]) >= demands[i]
    );

% Objective
solve minimize sum(j in 1..N)(use_pattern[j]);