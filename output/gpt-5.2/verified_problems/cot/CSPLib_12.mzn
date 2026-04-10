% Parameters
int: rows;
int: cols;

int: row_rule_len;
array[1..rows, 1..row_rule_len] of int: row_rules;

int: col_rule_len;
array[1..cols, 1..col_rule_len] of int: col_rules;

% Variables
array[1..rows, 1..cols] of var bool: x; % true = shaded, false = empty

% Constraints
% Row rules
constraint
forall(r in 1..rows) (
  let {
    int: K = row_rule_len,
    array[1..K] of int: len = [ row_rules[r,k] | k in 1..K ],
    set of int: POS = 1..cols
  } in
  exists(s in array[1..K] of var POS) (
    % non-decreasing; strictly increasing when both blocks are positive
    forall(k in 1..K-1) (
      if len[k] > 0 /\ len[k+1] > 0 then
        s[k+1] >= s[k] + len[k] + 1
      else
        s[k+1] >= s[k]
      endif
    )
    /\
    % each positive block fits in the row
    forall(k in 1..K) (
      (len[k] = 0) \/ (s[k] + len[k] - 1 <= cols)
    )
    /\
    % link blocks to cells: a cell is shaded iff it is covered by some positive block
    forall(c in 1..cols) (
      x[r,c] <->
      exists(k in 1..K where len[k] > 0) (
        s[k] <= c /\ c <= s[k] + len[k] - 1
      )
    )
  )
);

% Column rules
constraint
forall(c in 1..cols) (
  let {
    int: K = col_rule_len,
    array[1..K] of int: len = [ col_rules[c,k] | k in 1..K ],
    set of int: POS = 1..rows
  } in
  exists(s in array[1..K] of var POS) (
    % non-decreasing; strictly increasing when both blocks are positive
    forall(k in 1..K-1) (
      if len[k] > 0 /\ len[k+1] > 0 then
        s[k+1] >= s[k] + len[k] + 1
      else
        s[k+1] >= s[k]
      endif
    )
    /\
    % each positive block fits in the column
    forall(k in 1..K) (
      (len[k] = 0) \/ (s[k] + len[k] - 1 <= rows)
    )
    /\
    % link blocks to cells: a cell is shaded iff it is covered by some positive block
    forall(r in 1..rows) (
      x[r,c] <->
      exists(k in 1..K where len[k] > 0) (
        s[k] <= r /\ r <= s[k] + len[k] - 1
      )
    )
  )
);

% Objective
solve satisfy;