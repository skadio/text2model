% Parameters
int: rows;                         % Number of rows in the grid
int: cols;                         % Number of columns in the grid

int: row_rule_len;                 % Number of rule entries provided per row
int: col_rule_len;                 % Number of rule entries provided per column

array[1..rows, 1..row_rule_len] of int: row_rules;  % Row block-length constraints (often padded with 0s)
array[1..cols, 1..col_rule_len] of int: col_rules;  % Column block-length constraints (often padded with 0s)

% Variables
array[1..rows, 1..cols] of var 0..1: shade;         % 1 if cell is shaded/filled, 0 otherwise

% Helper variables: start positions for each block (parked at 1 if rule length is 0)
array[1..rows, 1..row_rule_len] of var 1..cols: row_block_start; % Start column of each row block
array[1..cols, 1..col_rule_len] of var 1..rows: col_block_start; % Start row of each column block

% Constraints

%----------------------------
% Helper: treat 0 rule entries as "no block"
% Enforce a canonical form: once a 0 appears in a rule list, all later entries are 0.
%----------------------------
constraint
  forall(r in 1..rows, k in 1..row_rule_len-1) (
    (row_rules[r,k] = 0) -> (row_rules[r,k+1] = 0)
  );

constraint
  forall(c in 1..cols, k in 1..col_rule_len-1) (
    (col_rules[c,k] = 0) -> (col_rules[c,k+1] = 0)
  );

%----------------------------
% Row blocks: bounds, separation, and coverage
%----------------------------

% Each row block must start so it fits within the row if it is active (length > 0)
constraint
  forall(r in 1..rows, k in 1..row_rule_len) (
    (row_rules[r,k] > 0) ->
      (row_block_start[r,k] + row_rules[r,k] - 1 <= cols)
  );

% If a row rule entry is 0, we "park" its start at 1 to avoid unconstrained vars
constraint
  forall(r in 1..rows, k in 1..row_rule_len) (
    (row_rules[r,k] = 0) -> (row_block_start[r,k] = 1)
  );

% Enforce ordering and at least one white cell gap between consecutive active blocks
constraint
  forall(r in 1..rows, k in 1..row_rule_len-1) (
    (row_rules[r,k] > 0 /\ row_rules[r,k+1] > 0) ->
      (row_block_start[r,k+1] >= row_block_start[r,k] + row_rules[r,k] + 1)
  );

% If a cell is shaded, it must belong to (at least) one active row block interval.
constraint
  forall(r in 1..rows, j in 1..cols) (
    shade[r,j] = 1 ->
      exists(k in 1..row_rule_len) (
        row_rules[r,k] > 0 /\
        row_block_start[r,k] <= j /\
        j <= row_block_start[r,k] + row_rules[r,k] - 1
      )
  );

% Every cell covered by an active row block must be shaded.
constraint
  forall(r in 1..rows, k in 1..row_rule_len) (
    (row_rules[r,k] > 0) ->
      forall(j in 1..cols) (
        (row_block_start[r,k] <= j /\ j <= row_block_start[r,k] + row_rules[r,k] - 1) ->
          (shade[r,j] = 1)
      )
  );

% Total shaded cells per row equals sum of its block lengths.
constraint
  forall(r in 1..rows) (
    sum(j in 1..cols)(shade[r,j]) = sum(k in 1..row_rule_len)(row_rules[r,k])
  );

%----------------------------
% Column blocks: bounds, separation, and coverage
%----------------------------

% Each column block must start so it fits within the column if it is active (length > 0)
constraint
  forall(c in 1..cols, k in 1..col_rule_len) (
    (col_rules[c,k] > 0) ->
      (col_block_start[c,k] + col_rules[c,k] - 1 <= rows)
  );

% If a column rule entry is 0, park its start at 1
constraint
  forall(c in 1..cols, k in 1..col_rule_len) (
    (col_rules[c,k] = 0) -> (col_block_start[c,k] = 1)
  );

% Enforce ordering and at least one white cell gap between consecutive active blocks
constraint
  forall(c in 1..cols, k in 1..col_rule_len-1) (
    (col_rules[c,k] > 0 /\ col_rules[c,k+1] > 0) ->
      (col_block_start[c,k+1] >= col_block_start[c,k] + col_rules[c,k] + 1)
  );

% If a cell is shaded, it must belong to (at least) one active column block interval.
constraint
  forall(i in 1..rows, c in 1..cols) (
    shade[i,c] = 1 ->
      exists(k in 1..col_rule_len) (
        col_rules[c,k] > 0 /\
        col_block_start[c,k] <= i /\
        i <= col_block_start[c,k] + col_rules[c,k] - 1
      )
  );

% Every cell covered by an active column block must be shaded.
constraint
  forall(c in 1..cols, k in 1..col_rule_len) (
    (col_rules[c,k] > 0) ->
      forall(i in 1..rows) (
        (col_block_start[c,k] <= i /\ i <= col_block_start[c,k] + col_rules[c,k] - 1) ->
          (shade[i,c] = 1)
      )
  );

% Total shaded cells per column equals sum of its block lengths.
constraint
  forall(c in 1..cols) (
    sum(i in 1..rows)(shade[i,c]) = sum(k in 1..col_rule_len)(col_rules[c,k])
  );

% Objective
solve satisfy;