include "alldifferent.mzn";

int: r;
int: c;
array[1..r, 1..c] of int: puzzle;

set of int: ROWS = 1..r;
set of int: COLS = 1..c;
set of int: CELLS = 1..r*c;

function int: idx(int: i, int: j) = (i-1)*c + j;

array[CELLS] of var 0..r*c: x;

constraint
  forall(i in ROWS, j in COLS) (
    x[idx(i,j)] = puzzle[i,j]
  );

int: N = max(i in ROWS, j in COLS)(puzzle[i,j]);

array[1..N] of var CELLS: pos;

constraint all_different(pos);

constraint
  forall(i in ROWS, j in COLS where puzzle[i,j] > 0) (
    pos[puzzle[i,j]] = idx(i,j)
  );

constraint
  forall(k in 1..N) (
    x[pos[k]] = k
  );

predicate adjacent(int: a, int: b) =
  let {
    int: ra = (a-1) div c + 1,
    int: ca = (a-1) mod c + 1,
    int: rb = (b-1) div c + 1,
    int: cb = (b-1) mod c + 1
  } in
    abs(ra - rb) <= 1 /\ abs(ca - cb) <= 1 /\ not (ra = rb /\ ca = cb);

constraint
  forall(k in 1..N-1) (
    adjacent(pos[k], pos[k+1])
  );

solve satisfy;

output [
  if j=1 then "\n" else " " endif ++ show(x[idx(i,j)])
  | i in ROWS, j in COLS
];