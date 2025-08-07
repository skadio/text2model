include "globals.mzn";

int: rows;                     % Number of rows in the grid
int: row_rule_len;             % Length of row_rules for each row
array[1..rows, 1..row_rule_len] of int: row_rules; % Constraints for each row
int: cols;                     % Number of columns in the grid
int: col_rule_len;             % Length of col_rules for each column
array[1..cols, 1..col_rule_len] of int: col_rules; % Constraints for each column

% Variables
array[1..rows, 1..cols] of var 0..1: grid; % 0 = unshaded, 1 = shaded

% Constraints for rows
constraint forall(r in 1..rows) (
    let {
        var int: total_shaded = sum(row_rules[r, j] | j in 1..row_rule_len);
        var int: total_blocks = row_rule_len;
    } in
    let {
        var int: total_length = total_shaded + total_blocks - 1; % Total length needed for blocks and gaps
    } in
    constraint cumulative([grid[r, c] | c in 1..cols], [1 | c in 1..total_length], [row_rules[r, j] | j in 1..row_rule_len])
);

% Constraints for columns
constraint forall(c in 1..cols) (
    let {
        var int: total_shaded = sum(col_rules[c, j] | j in 1..col_rule_len);
        var int: total_blocks = col_rule_len;
    } in
    let {
        var int: total_length = total_shaded + total_blocks - 1; % Total length needed for blocks and gaps
    } in
    constraint cumulative([grid[r, c] | r in 1..rows], [1 | r in 1..total_length], [col_rules[c, j] | j in 1..col_rule_len])
);

% Solve & output
solve satisfy;
output [ "Grid = ", show(grid), "\n" ];