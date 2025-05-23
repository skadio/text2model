int: r;
int: c;
float: Z;
float: M;

set of int: ROWS = 1..r;
set of int: COLS = 1..c;

array[ROWS, COLS] of var float: x;
array[ROWS, COLS] of var float: u;

constraint
  forall(i in ROWS, j in COLS) (
    Z <= u[i, j] /\ u[i, j] <= M
  );

constraint
  forall(i in ROWS, j in COLS where i = 1 \/ i = r \/ j = 1 \/ j = c) (
    u[i, j] = x[i, j]
  );

constraint
  forall(i in 2..r - 1, j in 2..c - 1) (
    4.0 * u[i, j] = u[i - 1, j] + u[i + 1, j] + u[i, j - 1] + u[i, j + 1]
  );

solve minimize u[1, 1];