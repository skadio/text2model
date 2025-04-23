% Parameters
int: rows; % Number of rows in the grid
int: row_rule_len; % Length of row_rules for each row (number of constraints)
array[1..rows, 1..row_rule_len] of int: row_rules; % Constraints for each row in the grid indicating the sequence of shaded blocks
int: cols; % Number of columns in the grid
int: col_rule_len; % Length of col_rules for each column (number of constraints)
array[1..cols, 1..col_rule_len] of int: col_rules; % Constraints for each column in the grid indicating the sequence of shaded blocks

% Variables
array[1..rows, 1..cols] of var 0..1: grid; % Grid of squares, where 1 represents a shaded square and 0 represents an unshaded square

include "global_cardinality.mzn";

% Constraints

% Constraint for each row
constraint forall(i in 1..rows) (
  global_cardinality(
    [grid[i, j] | j in 1..cols], 
    [k | k in 1..row_rule_len], 
    [row_rules[i, k] | k in 1..row_rule_len]
  )
);

% Constraint for each column
constraint forall(j in 1..cols) (
  global_cardinality(
    [grid[i, j] | i in 1..rows], 
    [k | k in 1..col_rule_len], 
    [col_rules[j, k] | k in 1..col_rule_len]
  )
);

% Objective
solve satisfy;