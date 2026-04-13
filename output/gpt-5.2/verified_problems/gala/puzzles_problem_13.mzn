include "globals.mzn";

int: r;
int: c;
array[1..r, 1..c] of int: puzzle;

int: N = r*c;

% Decision variables: the number placed in each cell (1..N)
array[1..r, 1..c] of var 1..N: x;

% Fix the given clues
constraint forall(i in 1..r, j in 1..c) (
  puzzle[i,j] > 0 -> x[i,j] = puzzle[i,j]
);

% All numbers 1..N appear exactly once in the grid
constraint all_different([ x[i,j] | i in 1..r, j in 1..c ]);

% Neighbourhood (8 directions)
function bool: adjacent(int: r1, int: c1, int: r2, int: c2) =
  abs(r1 - r2) <= 1 /\ abs(c1 - c2) <= 1 /\ not (r1 = r2 /\ c1 = c2);

% Successor adjacency:
% For every k=1..N-1, the cell containing k must be adjacent to the cell containing k+1
constraint forall(k in 1..N-1) (
  exists(i1 in 1..r, j1 in 1..c, i2 in 1..r, j2 in 1..c) (
    x[i1,j1] = k /\ x[i2,j2] = k+1 /\ adjacent(i1,j1,i2,j2)
  )
);

solve satisfy;

output [
  "Hidato solution:\n"
] ++
[
  if j = 1 then "\n" else " " endif ++
  show(x[i,j])
  | i in 1..r, j in 1..c
] ++ ["\n"];