int: M;
int: N;
int: large_roll_width;
array[1..M] of int: demands;
array[1..M] of float: roll_width_options;
array[1..N, 1..M] of int: patterns;

array[1..N] of var 0..sum(demands): x;
var 0..sum(demands): total_large_rolls;

constraint total_large_rolls = sum(p in 1..N)(x[p]);

constraint forall(i in 1..M)(
  sum(p in 1..N)(patterns[p, i] * x[p]) >= demands[i]
);

solve minimize total_large_rolls;