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
  sum(j in 1..cols)(grid[i,j]) = sum(k in 1..row_rule_len)(row_rules[i,k])
);

constraint forall(j in 1..cols)(
  sum(i in 1..rows)(grid[i,j]) = sum(k in 1..col_rule_len)(col_rules[j,k])
);

% Objective
solve satisfy;