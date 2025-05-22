include "alldifferent.mzn";

int: n;
set of int: IDX = 1..n;

array[IDX] of var 1..n: queens;

constraint alldifferent(queens);

constraint
  forall(i, j in IDX where i < j) (
    abs(queens[i] - queens[j]) != j - i
  );

solve satisfy;