% Parameters
int: M;
int: N;
int: large_roll_width;
array[1..M] of int: demands;
array[1..M] of float: roll_width_options;
array[1..N, 1..M] of int: patterns;

% Variables
int: max_demand = max(demands);
array[1..N] of var 0..max_demand: x; % number of large rolls cut with pattern p

var 0..(N * max_demand): total_large_rolls = sum(p in 1..N)(x[p]);

% Constraints
constraint
  forall(p in 1..N, i in 1..M)(
    patterns[p,i] >= 0
  );

constraint
  forall(i in 1..M)(
    sum(p in 1..N)(patterns[p,i] * x[p]) >= demands[i]
  );

% Optional: ensure each pattern fits within the large roll width (tolerate float imprecision)
constraint
  forall(p in 1..N)(
    sum(i in 1..M)(int2float(patterns[p,i]) * roll_width_options[i]) <= int2float(large_roll_width) + 1e-6
  );

% Objective
solve minimize total_large_rolls;