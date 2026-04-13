% Parameters
int: rows;
int: cols;

int: row_rule_len;
int: col_rule_len;

array[1..rows, 1..row_rule_len] of int: row_rules;
array[1..cols, 1..col_rule_len] of int: col_rules;

% Variables
array[1..rows, 1..cols] of var 0..1: x;

% start positions for each block; 0 means "unused" when rule entry is 0
array[1..rows, 1..row_rule_len] of var 0..cols: rs;
array[1..cols, 1..col_rule_len] of var 0..rows: cs;

% Constraints
% Row starts: unused iff rule length is 0; otherwise within valid start range
constraint
  forall(r in 1..rows, k in 1..row_rule_len) (
    (row_rules[r,k] = 0 -> rs[r,k] = 0) /\
    (row_rules[r,k] > 0 -> rs[r,k] >= 1 /\ rs[r,k] <= cols - row_rules[r,k] + 1)
  );

% Row block order and separation (at least one white between consecutive positive blocks)
constraint
  forall(r in 1..rows, k in 1..row_rule_len-1) (
    (row_rules[r,k] = 0 -> rs[r,k+1] = 0) /\
    (row_rules[r,k] > 0 /\ row_rules[r,k+1] > 0 ->
      rs[r,k+1] >= rs[r,k] + row_rules[r,k] + 1
    )
  );

% Column starts: unused iff rule length is 0; otherwise within valid start range
constraint
  forall(c in 1..cols, k in 1..col_rule_len) (
    (col_rules[c,k] = 0 -> cs[c,k] = 0) /\
    (col_rules[c,k] > 0 -> cs[c,k] >= 1 /\ cs[c,k] <= rows - col_rules[c,k] + 1)
  );

% Column block order and separation (at least one white between consecutive positive blocks)
constraint
  forall(c in 1..cols, k in 1..col_rule_len-1) (
    (col_rules[c,k] = 0 -> cs[c,k+1] = 0) /\
    (col_rules[c,k] > 0 /\ col_rules[c,k+1] > 0 ->
      cs[c,k+1] >= cs[c,k] + col_rules[c,k] + 1
    )
  );

% Cell shading equivalence from row rules: x[r,c]=1 iff covered by some row block
constraint
  forall(r in 1..rows, c in 1..cols) (
    x[r,c] = bool2int(
      exists(k in 1..row_rule_len) (
        row_rules[r,k] > 0 /\
        rs[r,k] <= c /\ c <= rs[r,k] + row_rules[r,k] - 1
      )
    )
  );

% Cell shading equivalence from column rules (consistency): must match column blocks too
constraint
  forall(r in 1..rows, c in 1..cols) (
    x[r,c] = bool2int(
      exists(k in 1..col_rule_len) (
        col_rules[c,k] > 0 /\
        cs[c,k] <= r /\ r <= cs[c,k] + col_rules[c,k] - 1
      )
    )
  );

% Objective
solve satisfy;