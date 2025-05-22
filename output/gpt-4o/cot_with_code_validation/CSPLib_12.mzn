% Parameters
int: rows;
int: row_rule_len;
array[1..rows, 1..row_rule_len] of int: row_rules;

int: cols;
int: col_rule_len;
array[1..cols, 1..col_rule_len] of int: col_rules;

% Variables
array[1..rows, 1..cols] of var 0..1: grid;

array[1..rows, 1..row_rule_len] of var 0..cols: row_start;      % 0 = “unused”
array[1..cols, 1..col_rule_len] of var 0..rows: col_start;      % 0 = “unused”

array[1..rows, 1..cols, 1..row_rule_len] of var 0..1: in_block_row;
array[1..rows, 1..cols, 1..col_rule_len] of var 0..1: in_block_col;

% Constraints
%
% --- row start positions --------------------------------------------------
constraint
  forall(r in 1..rows, k in 1..row_rule_len)(
      (row_rules[r,k] == 0) -> (row_start[r,k] = 0)
  );

constraint
  forall(r in 1..rows, k in 1..row_rule_len)(
      (row_rules[r,k] > 0) ->
         ( row_start[r,k] >= 1 /\
           row_start[r,k] + row_rules[r,k] - 1 <= cols )
  );

% keep required gap (= at least one blank) between consecutive blocks
constraint
  forall(r in 1..rows, k in 1..row_rule_len-1)(
      (row_rules[r,k] > 0 /\ row_rules[r,k+1] > 0) ->
         ( row_start[r,k] + row_rules[r,k] + 1 <= row_start[r,k+1] )
  );

% --- column start positions ----------------------------------------------
constraint
  forall(c in 1..cols, k in 1..col_rule_len)(
      (col_rules[c,k] == 0) -> (col_start[c,k] = 0)
  );

constraint
  forall(c in 1..cols, k in 1..col_rule_len)(
      (col_rules[c,k] > 0) ->
         ( col_start[c,k] >= 1 /\
           col_start[c,k] + col_rules[c,k] - 1 <= rows )
  );

constraint
  forall(c in 1..cols, k in 1..col_rule_len-1)(
      (col_rules[c,k] > 0 /\ col_rules[c,k+1] > 0) ->
         ( col_start[c,k] + col_rules[c,k] + 1 <= col_start[c,k+1] )
  );

% --- membership of cells in row blocks -----------------------------------
constraint
  forall(r in 1..rows, c in 1..cols, k in 1..row_rule_len)(
      (row_rules[r,k] == 0) ->
         (in_block_row[r,c,k] = 0)
  );

constraint
  forall(r in 1..rows, c in 1..cols, k in 1..row_rule_len)(
      (row_rules[r,k] > 0) ->
         (in_block_row[r,c,k] = bool2int(
               row_start[r,k] <= c /\
               c < row_start[r,k] + row_rules[r,k]))
  );

% --- membership of cells in column blocks --------------------------------
constraint
  forall(r in 1..rows, c in 1..cols, k in 1..col_rule_len)(
      (col_rules[c,k] == 0) ->
         (in_block_col[r,c,k] = 0)
  );

constraint
  forall(r in 1..rows, c in 1..cols, k in 1..col_rule_len)(
      (col_rules[c,k] > 0) ->
         (in_block_col[r,c,k] = bool2int(
               col_start[c,k] <= r /\
               r < col_start[c,k] + col_rules[c,k]))
  );

% --- link row representation to grid -------------------------------------
constraint
  forall(r in 1..rows, c in 1..cols)(
      grid[r,c] = sum(k in 1..row_rule_len)(in_block_row[r,c,k])
  );

% --- link column representation to grid ----------------------------------
constraint
  forall(r in 1..rows, c in 1..cols)(
      grid[r,c] = sum(k in 1..col_rule_len)(in_block_col[r,c,k])
  );

% Objective
solve satisfy;