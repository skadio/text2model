include "globals.mzn";

int: rows;
int: cols;

int: row_rule_len;
int: col_rule_len;

array[1..rows, 1..row_rule_len] of int: row_rules; % 0 allowed as padding
array[1..cols, 1..col_rule_len] of int: col_rules; % 0 allowed as padding

array[1..rows, 1..cols] of var bool: x; % true = shaded

function int: num_pos_row(int: r) = sum(k in 1..row_rule_len)(bool2int(row_rules[r,k] > 0));
function int: num_pos_col(int: c) = sum(k in 1..col_rule_len)(bool2int(col_rules[c,k] > 0));

constraint
forall(r in 1..rows)(
  let {
    int: m = num_pos_row(r),
    array[1..row_rule_len] of var 0..cols: s
  } in
  (
    forall(k in 1..row_rule_len)(
      row_rules[r,k] = 0 <-> s[k] = 0
    )
    /\
    forall(k in 1..row_rule_len-1 where row_rules[r,k] > 0 /\ row_rules[r,k+1] > 0)(
      s[k] + row_rules[r,k] + 1 <= s[k+1]
    )
    /\
    forall(k in 1..row_rule_len where row_rules[r,k] > 0)(
      1 <= s[k] /\ s[k] + row_rules[r,k] - 1 <= cols
    )
    /\
    forall(k in 1..row_rule_len-1)(
      s[k] <= s[k+1]
    )
    /\
    forall(j in 1..cols)(
      x[r,j] <-> exists(k in 1..row_rule_len where row_rules[r,k] > 0)(
        s[k] <= j /\ j < s[k] + row_rules[r,k]
      )
    )
    /\
    (m = 0 -> forall(j in 1..cols)(not x[r,j]))
  )
);

constraint
forall(c in 1..cols)(
  let {
    int: m = num_pos_col(c),
    array[1..col_rule_len] of var 0..rows: s
  } in
  (
    forall(k in 1..col_rule_len)(
      col_rules[c,k] = 0 <-> s[k] = 0
    )
    /\
    forall(k in 1..col_rule_len-1 where col_rules[c,k] > 0 /\ col_rules[c,k+1] > 0)(
      s[k] + col_rules[c,k] + 1 <= s[k+1]
    )
    /\
    forall(k in 1..col_rule_len where col_rules[c,k] > 0)(
      1 <= s[k] /\ s[k] + col_rules[c,k] - 1 <= rows
    )
    /\
    forall(k in 1..col_rule_len-1)(
      s[k] <= s[k+1]
    )
    /\
    forall(i in 1..rows)(
      x[i,c] <-> exists(k in 1..col_rule_len where col_rules[c,k] > 0)(
        s[k] <= i /\ i < s[k] + col_rules[c,k]
      )
    )
    /\
    (m = 0 -> forall(i in 1..rows)(not x[i,c]))
  )
);

solve satisfy;

output [
  if x[i,j] then "#" else "." endif ++ if j = cols then "\n" else "" endif
  | i in 1..rows, j in 1..cols
];