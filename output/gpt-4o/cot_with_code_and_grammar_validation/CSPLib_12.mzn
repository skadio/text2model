% Parameters
int: rows;
int: cols;
int: row_rule_len;
int: col_rule_len;

array[1..rows, 1..row_rule_len] of int: row_rules;
array[1..cols, 1..col_rule_len] of int: col_rules;

set of int: ROWS       = 1..rows;
set of int: COLS       = 1..cols;
set of int: ROW_RULES  = 1..row_rule_len;
set of int: COL_RULES  = 1..col_rule_len;

% Variables
array[ROWS, COLS] of var bool: grid;

array[ROWS, ROW_RULES] of var 0..cols: start_row;     % 0 ⇒ rule not used
array[COLS, COL_RULES] of var 0..rows: start_col;     % 0 ⇒ rule not used

% Constraints
%% --- Row-block positioning --------------------------------------------------
constraint
  forall(r in ROWS, k in ROW_RULES) (
        (row_rules[r,k] = 0) -> (start_row[r,k] = 0)
  );

constraint
  forall(r in ROWS, k in ROW_RULES where row_rules[r,k] > 0) (
        start_row[r,k] >= 1 /\
        start_row[r,k] <= cols - row_rules[r,k] + 1
  );

constraint
  forall(r in ROWS, k in 2..row_rule_len) (
        (row_rules[r,k-1] > 0 /\ row_rules[r,k] > 0) ->
        start_row[r,k] >= start_row[r,k-1] + row_rules[r,k-1] + 1
  );

%% --- Column-block positioning ----------------------------------------------
constraint
  forall(c in COLS, k in COL_RULES) (
        (col_rules[c,k] = 0) -> (start_col[c,k] = 0)
  );

constraint
  forall(c in COLS, k in COL_RULES where col_rules[c,k] > 0) (
        start_col[c,k] >= 1 /\
        start_col[c,k] <= rows - col_rules[c,k] + 1
  );

constraint
  forall(c in COLS, k in 2..col_rule_len) (
        (col_rules[c,k-1] > 0 /\ col_rules[c,k] > 0) ->
        start_col[c,k] >= start_col[c,k-1] + col_rules[c,k-1] + 1
  );

%% --- Link grid with row descriptions ---------------------------------------
constraint
  forall(r in ROWS, c in COLS)(
        grid[r,c] <-> 
        exists(k in ROW_RULES where row_rules[r,k] > 0)(
              start_row[r,k] <= c /\
              c < start_row[r,k] + row_rules[r,k]
        )
  );

%% --- Link grid with column descriptions ------------------------------------
constraint
  forall(c in COLS, r in ROWS)(
        grid[r,c] <-> 
        exists(k in COL_RULES where col_rules[c,k] > 0)(
              start_col[c,k] <= r /\
              r < start_col[c,k] + col_rules[c,k]
        )
  );

% Objective
solve satisfy;