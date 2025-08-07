include "globals.mzn";

/* Problem data from the .dzn file */
int: r;
int: c;
array[1..r, 1..c] of int: puzzle;

/* Derived constant */
int: N = r * c;

/* Decision variables */
/* board: 2D grid representation */
array[1..r, 1..c] of var 1..N: board;
/* Flattened board for ease of permutation/inverse handling */
array[1..N] of var 1..N: board_flat;
/* pos: inverse of board_flat such that board_flat[pos[k]] = k */
array[1..N] of var 1..N: pos;

/* Link board and board_flat */
constraint
  forall(i in 1..r, j in 1..c) (
    let { int: idx = (i - 1) * c + j } in
      board[i,j] = board_flat[idx]
  );

/* Fixed clues from the puzzle:
   Non-zero values in the puzzle must appear at the same cell in board. */
constraint
  forall(i in 1..r, j in 1..c where puzzle[i,j] != 0) (
    board[i,j] = puzzle[i,j]
  );

/* All cells must contain different values */
constraint all_different(board_flat);

/* Inverse constraint: for every k, board_flat[pos[k]] = k */
constraint inverse(board_flat, pos);

/* Helper functions to compute row and column from flattened index */
function var int: row_of(var int: idx) = 1 + (idx - 1) div c;
function var int: col_of(var int: idx) = 1 + (idx - 1) mod c;

/* Consecutive numbers must be placed in adjacent cells.
   For every k from 1 to N-1, the cells for k and k+1 must be neighbours.
   They are neighbours if the row and column differences are at most 1. */
constraint
  forall(k in 1..N-1) (
    let {
      var int: r1 = row_of(pos[k]),
      var int: c1 = col_of(pos[k]),
      var int: r2 = row_of(pos[k+1]),
      var int: c2 = col_of(pos[k+1])
    } in
      abs(r1 - r2) <= 1 /\ abs(c1 - c2) <= 1
  );

/* Solve */
solve satisfy;

/* Output the solved board as a grid */
output [
  if j = 1 then "\n" else " " endif ++ show(board[i,j])
  | i in 1..r, j in 1..c
];