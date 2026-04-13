% Parameters
int: r;
int: c;
array[1..r, 1..c] of int: puzzle;

% Number of cells / numbers
int: N = r * c;

% Decision variables: value in each cell
array[1..r, 1..c] of var 1..N: x;

% For each number n, its row and column position
array[1..N] of var 1..r: rowOf;
array[1..N] of var 1..c: colOf;

% Prefilled cells
constraint
  forall(i in 1..r, j in 1..c) (
    puzzle[i,j] > 0 -> x[i,j] = puzzle[i,j]
  );

% All numbers appear exactly once on the grid
constraint
  alldifferent([x[i,j] | i in 1..r, j in 1..c]);

% Link x <-> (rowOf, colOf) using element on a flattened array
array[1..N] of var 1..N: xf = [x[i,j] | i in 1..r, j in 1..c];

constraint
  forall(n in 1..N) (
    xf[(rowOf[n]-1) * c + colOf[n]] = n
  );

% Consecutive numbers must be adjacent (including diagonals), not the same cell
constraint
  forall(n in 1..N-1) (
    abs(rowOf[n] - rowOf[n+1]) <= 1 /\
    abs(colOf[n] - colOf[n+1]) <= 1 /\
    (rowOf[n] != rowOf[n+1] \/ colOf[n] != colOf[n+1])
  );

solve satisfy;