int: rows;
int: cols;

int: row_rule_len;
int: col_rule_len;

array[1..rows, 1..row_rule_len] of int: row_rules;
array[1..cols, 1..col_rule_len] of int: col_rules;

array[1..rows, 1..cols] of var bool: x;

constraint
  forall(r in 1..rows) (
    let {
      int: K = row_rule_len;
      array[1..K] of int: len = [ row_rules[r,k] | k in 1..K ];
      array[1..K] of var 0..cols: s;
      array[1..K] of var bool: used;
      array[1..K] of var 0..cols: start_eff;
    } in
    (
      forall(k in 1..K) (
        (used[k] <-> (len[k] > 0)) /\
        (used[k] -> (s[k] >= 1 /\ s[k] + len[k] - 1 <= cols)) /\
        ((not used[k]) -> (s[k] = 0))
      )
      /\
      forall(k in 1..K) (
        start_eff[k] = s[k] * bool2int(used[k])
      )
      /\
      forall(k in 1..K-1) (
        (used[k] /\ used[k+1]) ->
          (s[k+1] >= s[k] + len[k] + 1)
      )
      /\
      forall(k in 1..K-1) (
        used[k+1] -> used[k]
      )
      /\
      forall(c in 1..cols) (
        x[r,c] <-> exists(k in 1..K) (
          used[k] /\ s[k] <= c /\ c <= s[k] + len[k] - 1
        )
      )
    )
  );

constraint
  forall(c in 1..cols) (
    let {
      int: K = col_rule_len;
      array[1..K] of int: len = [ col_rules[c,k] | k in 1..K ];
      array[1..K] of var 0..rows: s;
      array[1..K] of var bool: used;
    } in
    (
      forall(k in 1..K) (
        (used[k] <-> (len[k] > 0)) /\
        (used[k] -> (s[k] >= 1 /\ s[k] + len[k] - 1 <= rows)) /\
        ((not used[k]) -> (s[k] = 0))
      )
      /\
      forall(k in 1..K-1) (
        (used[k] /\ used[k+1]) ->
          (s[k+1] >= s[k] + len[k] + 1)
      )
      /\
      forall(k in 1..K-1) (
        used[k+1] -> used[k]
      )
      /\
      forall(r in 1..rows) (
        x[r,c] <-> exists(k in 1..K) (
          used[k] /\ s[k] <= r /\ r <= s[k] + len[k] - 1
        )
      )
    )
  );

solve satisfy;