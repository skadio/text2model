int: O;
int: P;
int: L;

array[1..O] of float: Allocated;
array[1..P] of float: Price;

array[1..L, 1..O] of float: Input;
array[1..L, 1..P] of float: Output;

array[1..L] of float: Cost;

array[1..L] of var 0.0..1.0e12: x;

constraint forall(l in 1..L) (x[l] >= 0.0);

constraint forall(o in 1..O) (
  sum(l in 1..L)(Input[l,o] * x[l]) <= Allocated[o]
);

solve maximize
  sum(l in 1..L, p in 1..P)(Price[p] * Output[l,p] * x[l])
  - sum(l in 1..L)(Cost[l] * x[l]);