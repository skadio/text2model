% Parameters
int: rows;                      % Number of rows in the grid
int: cols;                      % Number of columns in the grid

int: row_rule_len;              % Number of rule entries provided per row
int: col_rule_len;              % Number of rule entries provided per column

array[1..rows, 1..row_rule_len] of int: row_rules;  % Row block-length rules (0 can be used as padding)
array[1..cols, 1..col_rule_len] of int: col_rules;  % Column block-length rules (0 can be used as padding)

% Helpful index sets
set of int: ROWS = 1..rows;
set of int: COLS = 1..cols;
set of int: ROW_RULE_POS = 1..row_rule_len;
set of int: COL_RULE_POS = 1..col_rule_len;

% Variables
array[ROWS, COLS] of var 0..1: cell;  % cell[r,c] = 1 if shaded/filled, 0 otherwise

% Bookkeeping variables: filled counts per row/column
array[ROWS] of var 0..cols: row_filled;
array[COLS] of var 0..rows: col_filled;

% Start position model:
% For each row r and each possible block k (1..row_rule_len), let row_start[r,k]
% be the starting column of that block (arbitrary if rule is 0).
array[ROWS, ROW_RULE_POS] of var 1..cols: row_start;

% Similarly for columns: starting row positions.
array[COLS, COL_RULE_POS] of var 1..rows: col_start;

% Constraints

% --- Row/column filled-count bookkeeping ------------------------------------
constraint forall(r in ROWS) (
  row_filled[r] = sum(c in COLS)(cell[r,c])
);

constraint forall(c in COLS) (
  col_filled[c] = sum(r in ROWS)(cell[r,c])
);

% --- Basic feasibility checks: total required filled cells fit ---------------
constraint
  forall(r in ROWS) (
    let {
      int: blocks_r = sum(k in ROW_RULE_POS)(bool2int(row_rules[r,k] > 0)),
      int: filled_r = sum(k in ROW_RULE_POS)(row_rules[r,k])
    } in
      filled_r + max(0, blocks_r - 1) <= cols
  );

constraint
  forall(c in COLS) (
    let {
      int: blocks_c = sum(k in COL_RULE_POS)(bool2int(col_rules[c,k] > 0)),
      int: filled_c = sum(k in COL_RULE_POS)(col_rules[c,k])
    } in
      filled_c + max(0, blocks_c - 1) <= rows
  );

% --- Row rules (block start positions + exact equivalence to cell shading) ---
constraint
  forall(r in ROWS) (
    % blocks must be within bounds
    forall(k in ROW_RULE_POS where row_rules[r,k] > 0) (
      row_start[r,k] + row_rules[r,k] - 1 <= cols
    )
    /\
    % ordering + at least one gap between consecutive positive blocks
    forall(k in 1..row_rule_len-1 where row_rules[r,k] > 0 /\ row_rules[r,k+1] > 0) (
      row_start[r,k] + row_rules[r,k] <= row_start[r,k+1] - 1
    )
    /\
    % cell is filled iff it is covered by some positive block interval
    forall(c in COLS) (
      cell[r,c] = bool2int(
        exists(k in ROW_RULE_POS where row_rules[r,k] > 0) (
          row_start[r,k] <= c /\ c <= row_start[r,k] + row_rules[r,k] - 1
        )
      )
    )
  );

% --- Column rules (block start positions + exact equivalence to cell shading) -
constraint
  forall(c in COLS) (
    forall(k in COL_RULE_POS where col_rules[c,k] > 0) (
      col_start[c,k] + col_rules[c,k] - 1 <= rows
    )
    /\
    forall(k in 1..col_rule_len-1 where col_rules[c,k] > 0 /\ col_rules[c,k+1] > 0) (
      col_start[c,k] + col_rules[c,k] <= col_start[c,k+1] - 1
    )
    /\
    forall(r in ROWS) (
      cell[r,c] = bool2int(
        exists(k in COL_RULE_POS where col_rules[c,k] > 0) (
          col_start[c,k] <= r /\ r <= col_start[c,k] + col_rules[c,k] - 1
        )
      )
    )
  );

% Objective
solve satisfy;