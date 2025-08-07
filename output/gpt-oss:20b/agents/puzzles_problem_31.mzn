include "globals.mzn";

int: n;
array[1..n,1..n] of int: puzzle;   % -1 = unknown, >=0 = clue

/* Decision variables: 1 = painted, 0 = not painted */
array[1..n,1..n] of var 0..1: painted;

/* A clue cell is always painted (it counts itself) */
constraint
  forall(i in 1..n, j in 1..n where puzzle[i,j] >= 0) (
    painted[i,j] = 1
  );

/* For every clue cell, the number of painted cells in its 3×3
   neighbourhood (including the clue cell itself) must equal the
   clue value. */
constraint
  forall(i in 1..n, j in 1..n where puzzle[i,j] >= 0) (
    let {
      array[int] of var 0..1: neigh = [
        painted[ii,jj] |
        ii in max(i-1,1)..min(i+1,n),
        jj in max(j-1,1)..min(j+1,n)
      ]
    } in
    count(neigh, 1, puzzle[i,j])
  );

/* Solve */
solve satisfy;

/* Output the painted grid */
output [
  "Painted grid:\n",
  concat([ show(painted[i,j]) ++
           (if j < n then " " else "\n" endif) |
           i in 1..n, j in 1..n ])
];