int: M;
int: N;

float: large_roll_width;
array[1..M] of float: roll_width_options;
array[1..M] of int: demands;

% patterns[p, i] = number of small rolls of type i produced by pattern p
array[1..N, 1..M] of int: patterns;

set of int: TYPES = 1..M;
set of int: PATS  = 1..N;

% Optional: validate that each pattern fits within the large roll width (allowing tiny tolerance)
constraint
  forall(p in PATS)(
    sum(i in TYPES)(float(patterns[p,i]) * roll_width_options[i]) <= large_roll_width + 1e-6
  );

% Decision: how many large rolls are cut using each pattern
int: max_rolls = sum(i in TYPES)(demands[i]); % safe upper bound
array[PATS] of var 0..max_rolls: x;

% Meet or exceed demands for each roll type
constraint
  forall(i in TYPES)(
    sum(p in PATS)(patterns[p,i] * x[p]) >= demands[i]
  );

var 0..max_rolls: total_rolls = sum(p in PATS)(x[p]);

solve minimize total_rolls;

output [
  "total_rolls=", show(total_rolls), "\n",
  "x=", show(x), "\n"
];