% Parameters
int: M;
int: N;
float: large_roll_width;
array[1..M] of int: demands;
array[1..M] of float: roll_width_options;
array[1..N, 1..M] of int: patterns;

int: total_demand = sum(i in 1..M)(demands[i]);

% Variables
array[1..N] of var 0..total_demand: x;

% Constraints
constraint
  forall(i in 1..M)(
    sum(p in 1..N)(patterns[p,i] * x[p]) >= demands[i]
  );

constraint
  forall(p in 1..N)(
    sum(i in 1..M)(patterns[p,i] * roll_width_options[i]) <= large_roll_width
  );

% Objective
solve minimize sum(p in 1..N)(x[p]);