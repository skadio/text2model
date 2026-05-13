int: M;
int: N;
int: large_roll_width;

array[1..M] of int: demands;
array[1..M] of int: roll_width_options;
array[1..N, 1..M] of int: patterns;

int: max_int = 1000000;
var 0..max_int: x[1..N];

% Each type of paper must be produced in at least the demanded quantity
constraint
  forall(j in 1..M) (
    sum(i in 1..N) (patterns[i,j] * x[i]) >= demands[j]
  );

% Each pattern must fit into a single large roll
constraint
  forall(i in 1..N) (
    sum(j in 1..M) (patterns[i,j] * roll_width_options[j]) <= large_roll_width
  );

solve minimize sum(i in 1..N) x[i];

output [
  "Number of large rolls needed: " ++ show(sum(i in 1..N) x[i]) ++ "\n",
  "Pattern usage: " ++ show(x) ++ "\n",
  "Total produced per type: " ++ show([sum(i in 1..N) patterns[i,j] * x[i] | j in 1..M]) ++ "\n"
];