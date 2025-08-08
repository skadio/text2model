% Parameters
int: M; % number of roll types
int: N; % number of cutting patterns
int: large_roll_width; % width of a large roll
array[1..M] of int: demands; % demand for each roll type
array[1..M] of int: roll_width_options; % width of each roll type
array[1..N, 1..M] of int: patterns; % pattern matrix: patterns[p,i] = number of rolls of type i in pattern p

% Derived parameter
int: max_demand = sum(demands);

% Variables
array[1..N] of var 0..max_demand: x; % number of times each pattern is used

% Constraints
constraint
  forall(i in 1..M) (
    sum(p in 1..N) patterns[p,i] * x[p] >= demands[i]
  );

% Objective
solve minimize
  sum(p in 1..N) x[p];