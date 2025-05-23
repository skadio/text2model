include "globals.mzn";

% Parameters
int: rows; % Number of rows
int: row_rule_len; % Length of row_rules for each row
array[1..rows, 1..row_rule_len] of int: row_rules; % Constraints for each row

int: cols; % Number of columns
int: col_rule_len; % Length of col_rules for each column
array[1..cols, 1..col_rule_len] of int: col_rules; % Constraints for each column

% Variables
array[1..rows, 1..cols] of var 0..1: grid; % Grid of squares

% Constraints
constraint forall(i in 1..rows)(
  regular(
    [grid[i,j] | j in 1..cols],
    sum([row_rules[i,j] | j in 1..row_rule_len]) + row_rule_len - 1,
    array2d(0..row_rule_len, 0..1, 
      [if k = 0 then 1 else 0 endif | k in 0..row_rule_len, l in 0..1]),
    array2d(0..row_rule_len, 0..1, 
      [if k = 0 then 1 else 0 endif | k in 0..row_rule_len, l in 0..1]),
    1,
    row_rule_len
  )
);

constraint forall(j in 1..cols)(
  regular(
    [grid[i,j] | i in 1..rows],
    sum([col_rules[j,k] | k in 1..col_rule_len]) + col_rule_len - 1,
    array2d(0..col_rule_len, 0..1, 
      [if k = 0 then 1 else 0 endif | k in 0..col_rule_len, l in 0..1]),
    array2d(0..col_rule_len, 0..1, 
      [if k = 0 then 1 else 0 endif | k in 0..col_rule_len, l in 0..1]),
    1,
    col_rule_len
  )
);

% Objective
solve satisfy;