% Parameters
int: rows; % Number of rows in the grid
int: row_rule_len; % Length of row_rules for each row (number of constraints)
array[1..rows, 1..row_rule_len] of int: row_rules; % Constraints for each row in the grid indicating the sequence of shaded blocks
int: cols; % Number of columns in the grid
int: col_rule_len; % Length of col_rules for each column (number of constraints)
array[1..cols, 1..col_rule_len] of int: col_rules; % Constraints for each column in the grid indicating the sequence of shaded blocks

% Variables
array[1..rows, 1..cols] of var 0..1: grid; % Grid of squares, where 1 represents a shaded square and 0 represents an unshaded square

% Constraints

% Row constraints
constraint forall(i in 1..rows) (
  % The sequence of shaded blocks in each row must match the row_rules
  let {
    % Create a sequence of shaded blocks in the row
    array[int] of var int: row_sequence = [ sum(j in 1..cols) (if grid[i,j] = 1 then 1 else 0 endif) ];
  } in
  % The length of the sequence must match the row_rule_len
  length(row_sequence) = row_rule_len /\
  % The sequence must match the row_rules
  forall(k in 1..row_rule_len) (
    row_sequence[k] = row_rules[i,k]
  )
);

% Column constraints
constraint forall(i in 1..cols) (
  % The sequence of shaded blocks in each column must match the col_rules
  let {
    % Create a sequence of shaded blocks in the column
    array[int] of var int: col_sequence = [ sum(j in 1..rows) (if grid[j,i] = 1 then 1 else 0 endif) ];
  } in
  % The length of the sequence must match the col_rule_len
  length(col_sequence) = col_rule_len /\
  % The sequence must match the col_rules
  forall(k in 1..col_rule_len) (
    col_sequence[k] = col_rules[i,k]
  )
);

% Objective
solve satisfy;