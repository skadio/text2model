% Parameters
int: rows; % Number of rows in the grid
int: row_rule_len; % Length of row_rules for each row (number of constraints)
array[1..rows, 1..row_rule_len] of int: row_rules; % Constraints for each row in the grid indicating the sequence of shaded blocks
int: cols; % Number of columns in the grid
int: col_rule_len; % Length of col_rules for each column (number of constraints)
array[1..cols, 1..col_rule_len] of int: col_rules; % Constraints for each column in the grid indicating the sequence of shaded blocks

% Variables
array[1..rows, 1..cols] of var 0..1: grid; % Grid of squares, 1 if shaded, 0 otherwise

include "globals.mzn";

% Constraints
constraint forall(i in 1..rows)(
  let {
    array[1..cols] of var 0..1: row = [grid[i,j] | j in 1..cols]
  } in
  regular(row, max(row_rules[i,1..row_rule_len])+1, row_rule_len+2, array2d(1..row_rule_len+2, 1..max(row_rules[i,1..row_rule_len])+1, 
    function(i, j) = if i = j+1 then i else if i <= row_rule_len /\ j = row_rules[i] then i+1 else 0 endif endif), 1, row_rule_len+2)
);

constraint forall(j in 1..cols)(
  let {
    array[1..rows] of var 0..1: col = [grid[i,j] | i in 1..rows]
  } in
  regular(col, max(col_rules[j,1..col_rule_len])+1, col_rule_len+2, array2d(1..col_rule_len+2, 1..max(col_rules[j,1..col_rule_len])+1, 
    function(i, j) = if i = j+1 then i else if i <= col_rule_len /\ j = col_rules[j,i] then i+1 else 0 endif endif), 1, col_rule_len+2)
);

% Objective
solve satisfy;