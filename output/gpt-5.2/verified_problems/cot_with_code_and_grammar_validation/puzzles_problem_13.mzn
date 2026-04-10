include "globals.mzn";

int: r;
int: c;
array[1..r, 1..c] of int: puzzle;

int: N = r * c;

array[1..r, 1..c] of var 1..N: x;

constraint
  forall(i in 1..r, j in 1..c) (
    puzzle[i,j] > 0 -> x[i,j] = puzzle[i,j]
  );

constraint all_different([x[i,j] | i in 1..r, j in 1..c]);

predicate adj(int: i1, int: j1, int: i2, int: j2) =
  abs(i1 - i2) <= 1 /\ abs(j1 - j2) <= 1 /\ not (i1 = i2 /\ j1 = j2);

constraint
  forall(v in 1..N-1) (
    exists(i1 in 1..r, j1 in 1..c, i2 in 1..r, j2 in 1..c) (
      x[i1,j1] = v /\ x[i2,j2] = v + 1 /\ adj(i1,j1,i2,j2)
    )
  );

solve satisfy;