int: r;
int: c;
float: Z;
float: M;

set of int: ROWS = 1..r;
set of int: COLS = 1..c;

array[ROWS, COLS] of var float: x;

constraint forall(i in ROWS, j in COLS) (
  Z <= x[i, j] /\ x[i, j] <= M
);

constraint forall(i in 2..r-1, j in 2..c-1) (
  x[i, j] = (x[i-1, j] + x[i+1, j] + x[i, j-1] + x[i, j+1]) / 4.0
);

solve minimize x[1, 1];