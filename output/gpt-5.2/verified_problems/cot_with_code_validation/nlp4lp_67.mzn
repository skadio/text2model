% Cutting Stock Problem (minimize number of large rolls)

% Parameters
int: M;                         % number of roll types
int: N;                         % number of cutting patterns
int: large_roll_width;          % width of a large roll
array[1..M] of int: demands;    % demand for each roll type
array[1..M] of float: roll_width_options;  % widths (can be fractional)
array[1..N, 1..M] of int: patterns;        % pattern p produces patterns[p,i] rolls of type i

% Derived bounds / variables
int: max_rolls = sum(demands);
array[1..N] of var 0..max_rolls: use_pattern;

% Demand satisfaction
constraint
  forall(i in 1..M) (
    sum(p in 1..N) (patterns[p, i] * use_pattern[p]) >= demands[i]
  );

% Optional validity check: each pattern must fit in the large roll
constraint
  forall(p in 1..N) (
    sum(i in 1..M) (int2float(patterns[p, i]) * roll_width_options[i]) <= int2float(large_roll_width) + 1e-6
  );

% Objective: minimize number of large rolls used
solve minimize sum(p in 1..N) (use_pattern[p]);