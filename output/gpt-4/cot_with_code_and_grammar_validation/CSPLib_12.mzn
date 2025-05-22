% Parameters
int: rows;
int: row_rule_len;
array[1..rows, 1..row_rule_len] of int: row_rules;
int: cols;
int: col_rule_len;
array[1..cols, 1..col_rule_len] of int: col_rules;

% Variables
array[1..rows, 1..cols] of var 0..1: grid;

% Constraints
constraint forall(i in 1..rows)(
  forall(l in 1..row_rule_len)(
    let {
      array[1..cols-row_rules[i, l]+1] of var 0..cols: row_blocks = [ sum(j in 1..cols)(if j >= k /\ j < k + row_rules[i, l] then grid[i, j] else 0 endif) | k in 1..cols-row_rules[i, l]+1 ]
    } in
    sum(row_blocks) = row_rules[i, l]
  )
);

constraint forall(j in 1..cols)(
  forall(l in 1..col_rule_len)(
    let {
      array[1..rows-col_rules[j, l]+1] of var 0..rows: col_blocks = [ sum(i in 1..rows)(if i >= k /\ i < k + col_rules[j, l] then grid[i, j] else 0 endif) | k in 1..rows-col_rules[j, l]+1 ]
    } in
    sum(col_blocks) = col_rules[j, l]
  )
);

% Objective
solve satisfy;