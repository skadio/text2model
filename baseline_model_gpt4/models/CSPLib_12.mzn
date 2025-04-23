include "globals.mzn";

% Input parameters
int: rows;
int: row_rule_len;
array[1..rows, 1..row_rule_len] of int: row_rules;
int: cols;
int: col_rule_len;
array[1..cols, 1..col_rule_len] of int: col_rules;

% Decision variables
array[1..rows, 1..cols] of var 0..1: grid;

% Constraints
constraint forall(i in 1..rows)(
  regular(
    [grid[i,j] | j in 1..cols],
    sum([row_rules[i,j] | j in 1..row_rule_len]) + row_rule_len - 1,
    array2d(0..row_rule_len, 0..1, 
      [if k = 0 then 1 else 0 endif | k in 0..row_rule_len, _ in 0..1]),
    array2d(0..row_rule_len, 0..1, 
      [if k = 0 then 1 else 0 endif | k in 0..row_rule_len, _ in 0..1]),
    row_rules[i,1..row_rule_len]
  )
);

constraint forall(j in 1..cols)(
  regular(
    [grid[i,j] | i in 1..rows],
    sum([col_rules[j,k] | k in 1..col_rule_len]) + col_rule_len - 1,
    array2d(0..col_rule_len, 0..1, 
      [if k = 0 then 1 else 0 endif | k in 0..col_rule_len, _ in 0..1]),
    array2d(0..col_rule_len, 0..1, 
      [if k = 0 then 1 else 0 endif | k in 0..col_rule_len, _ in 0..1]),
    col_rules[j,1..col_rule_len]
  )
);

% Solve
solve satisfy;