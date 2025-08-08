include "globals.mzn";

/* ------------------------------------------------------------------ */
/*  Data                                                            */
/* ------------------------------------------------------------------ */
int: rows;                       % number of rows
int: row_rule_len;               % maximum number of rules per row
array[1..rows, 1..row_rule_len] of int: row_rules;

int: cols;                       % number of columns
int: col_rule_len;               % maximum number of rules per column
array[1..cols, 1..col_rule_len] of int: col_rules;

/* ------------------------------------------------------------------ */
/*  Decision variables                                               */
/* ------------------------------------------------------------------ */
array[1..rows, 1..cols] of var 0..1: grid;   % shaded / unshaded cells

% start positions of blocks (0 means “no block”)
array[1..rows, 1..row_rule_len] of var 0..cols: startRow;
array[1..cols, 1..col_rule_len] of var 0..rows: startCol;

/* ------------------------------------------------------------------ */
/*  Constraints                                                     */
/* ------------------------------------------------------------------ */

/* ----  Row block starts ------------------------------------------ */
constraint forall(i in 1..rows, k in 1..row_rule_len) (
  (row_rules[i,k] == 0) -> startRow[i,k] = 0
  /\ (row_rules[i,k] > 0) -> (1 <= startRow[i,k] /\ startRow[i,k] <= cols - row_rules[i,k] + 1)
);

/* ----  Order of blocks in each row -------------------------------- */
constraint forall(i in 1..rows, k in 1..row_rule_len-1) (
  (row_rules[i,k] > 0 /\ row_rules[i,k+1] > 0) ->
    startRow[i,k+1] >= startRow[i,k] + row_rules[i,k] + 1
);

/* ----  Column block starts ---------------------------------------- */
constraint forall(j in 1..cols, k in 1..col_rule_len) (
  (col_rules[j,k] == 0) -> startCol[j,k] = 0
  /\ (col_rules[j,k] > 0) -> (1 <= startCol[j,k] /\ startCol[j,k] <= rows - col_rules[j,k] + 1)
);

/* ----  Order of blocks in each column ------------------------------ */
constraint forall(j in 1..cols, k in 1..col_rule_len-1) (
  (col_rules[j,k] > 0 /\ col_rules[j,k+1] > 0) ->
    startCol[j,k+1] >= startCol[j,k] + col_rules[j,k] + 1
);

/* ----  Grid defined by row blocks -------------------------------- */
constraint forall(i in 1..rows, j in 1..cols) (
  grid[i,j] = bool2int(
    sum([ if (row_rules[i,k] > 0 /\ startRow[i,k] > 0
               /\ j >= startRow[i,k]
               /\ j <= startRow[i,k] + row_rules[i,k] - 1)
           then 1 else 0
         | k in 1..row_rule_len]) > 0
  )
);

/* ----  Grid defined by column blocks (must agree with rows) -------- */
constraint forall(i in 1..rows, j in 1..cols) (
  grid[i,j] = bool2int(
    sum([ if (col_rules[j,k] > 0 /\ startCol[j,k] > 0
               /\ i >= startCol[j,k]
               /\ i <= startCol[j,k] + col_rules[j,k] - 1)
           then 1 else 0
         | k in 1..col_rule_len]) > 0
  )
);

/* ------------------------------------------------------------------ */
/*  Solve and output                                                */
/* ------------------------------------------------------------------ */
solve satisfy;

output [
  concat([ show(grid[i,j]) | j in 1..cols ]) ++ "\n" | i in 1..rows
];