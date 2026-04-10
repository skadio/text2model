int: n;
array[1..n, 1..n] of int: puzzle;

set of int: IDX = 1..n;
set of int: VALS = 0..9;
int: UNKNOWN = -1;

array[IDX, IDX] of var 0..1: paint;

constraint
  forall(i in IDX, j in IDX) (
    puzzle[i, j] in VALS \/ puzzle[i, j] = UNKNOWN
  );

constraint
  forall(i in IDX, j in IDX where puzzle[i, j] != UNKNOWN) (
    sum(di in -1..1, dj in -1..1 where i + di in IDX /\ j + dj in IDX)(
      paint[i + di, j + dj]
    ) = puzzle[i, j]
  );

solve satisfy;