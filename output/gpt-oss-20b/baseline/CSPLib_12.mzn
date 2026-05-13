int: rows;
int: row_rule_len;
array[1..rows, 1..row_rule_len] of int: row_rules;
int: cols;
int: col_rule_len;
array[1..cols, 1..col_rule_len] of int: col_rules;

array[1..rows] of int: row_rule_count = array1d(1..rows, [sum([bool2int(row_rules[i,j] != 0) | j in 1..row_rule_len]) | i in 1..rows]);
array[1..cols] of int: col_rule_count = array1d(1..cols, [sum([bool2int(col_rules[j,k] != 0) | k in 1..col_rule_len]) | j in 1..cols]);

array[1..rows, 1..cols] of var bool: grid;
array[1..rows, 1..row_rule_len] of var 0..cols: run_start_row;
array[1..cols, 1..col_rule_len] of var 0..rows: run_start_col;

constraint
  forall(i in 1..rows, j in 1..row_rule_len) (
    (j <= row_rule_count[i]) -> (run_start_row[i,j] >= 1 /\ run_start_row[i,j] <= cols - row_rules[i,j] + 1)
  ) /\
  forall(i in 1..rows, j in 1..row_rule_len) (
    (j > row_rule_count[i]) -> (run_start_row[i,j] = 0)
  ) /\
  forall(i in 1..rows, j in 1..row_rule_len-1) (
    (j <= row_rule_count[i] /\ j+1 <= row_rule_count[i]) ->
      (run_start_row[i,j+1] >= run_start_row[i,j] + row_rules[i,j] + 1)
  ) /\
  forall(i in 1..rows, j in 1..row_rule_len) (
    (j <= row_rule_count[i]) ->
      (run_start_row[i,j] + row_rules[i,j] - 1 <= cols)
  ) /\
  forall(i in 1..rows, c in 1..cols) (
    grid[i,c] = (sum([bool2int(c >= run_start_row[i,j] /\ c <= run_start_row[i,j] + row_rules[i,j] - 1) | j in 1..row_rule_len]) > 0)
  );

constraint
  forall(j in 1..cols, k in 1..col_rule_len) (
    (k <= col_rule_count[j]) -> (run_start_col[j,k] >= 1 /\ run_start_col[j,k] <= rows - col_rules[j,k] + 1)
  ) /\
  forall(j in 1..cols, k in 1..col_rule_len) (
    (k > col_rule_count[j]) -> (run_start_col[j,k] = 0)
  ) /\
  forall(j in 1..cols, k in 1..col_rule_len-1) (
    (k <= col_rule_count[j] /\ k+1 <= col_rule_count[j]) ->
      (run_start_col[j,k+1] >= run_start_col[j,k] + col_rules[j,k] + 1)
  ) /\
  forall(j in 1..cols, k in 1..col_rule_len) (
    (k <= col_rule_count[j]) ->
      (run_start_col[j,k] + col_rules[j,k] - 1 <= rows)
  ) /\
  forall(j in 1..cols, i in 1..rows) (
    grid[i,j] = (sum([bool2int(i >= run_start_col[j,k] /\ i <= run_start_col[j,k] + col_rules[j,k] - 1) | k in 1..col_rule_len]) > 0)
  );

solve satisfy;

output [
  if j == 1 then (if i == 1 then "" else "\n") else "" endif ++
  (if grid[i,j] then "1" else "0") | i in 1..rows, j in 1..cols
];