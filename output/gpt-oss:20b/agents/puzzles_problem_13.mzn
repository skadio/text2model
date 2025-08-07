include "globals.mzn";

/* --- Parameters (filled in by the .dzn file) --- */
int: r;                     % number of rows
int: c;                     % number of columns
array[1..r,1..c] of int: puzzle;   % 0 = empty, otherwise a fixed value

/* --- Decision variables --- */
array[1..r,1..c] of var 1..r*c: cell;

/* --- Constraints --- */

/* 1. all numbers appear exactly once */
constraint all_different(cell);

/* 2. respect the given numbers */
constraint forall(i in 1..r, j in 1..c)(
  puzzle[i][j] != 0 -> cell[i][j] == puzzle[i][j]
);

/* 3. consecutive numbers must be in adjacent cells (8‑neighbourhood) */
int: maxVal = r*c;
constraint forall(k in 1..maxVal-1)(
  exists(i in 1..r, j in 1..c)(
    cell[i][j] == k /\
    exists(i2 in max(1,i-1)..min(r,i+1),
           j2 in max(1,j-1)..min(c,j+1))(
      (i2 != i \/ j2 != j) /\ cell[i2][j2] == k+1
    )
  )
);

/* --- Search --- */
solve satisfy;

/* --- Output --- */
output [
  "Solution:\n",
  concat([ concat([ show(cell[i][j]) ++ if j < c then " " else "" endif |
                     j in 1..c ]) ++ "\n" | i in 1..r ])
];