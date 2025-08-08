% Parameters
int: rows;
int: row_rule_len;
array[1..rows, 1..row_rule_len] of int: row_rules;
int: cols;
int: col_rule_len;
array[1..cols, 1..col_rule_len] of int: col_rules;

% Variables
array[1..rows, 1..cols] of var 0..1: grid;

% Helper function to build a regular‑expression string from a rule
function string build_regex(array[int] of int: rule) =
  let {
    array[1..length(rule)] of string: block_str =
      [ if rule[j] > 0 then "1{" ++ int2str(rule[j]) ++ "}0+" else "" endif
        | j in 1..length(rule) ];
    string: block_part = concat(block_str);
  } in
  "0*" ++ block_part ++ "0*";

% Regular‑expression strings for each row and column
array[1..rows] of string: row_regex =
  [ build_regex([row_rules[i,j] | j in 1..row_rule_len]) | i in 1..rows ];

array[1..cols] of string: col_regex =
  [ build_regex([col_rules[j,i] | i in 1..col_rule_len]) | j in 1..cols ];

% Constraints
constraint forall(i in 1..rows) (
  regular(row_regex[i], [grid[i,j] | j in 1..cols])
);

constraint forall(j in 1..cols) (
  regular(col_regex[j], [grid[i,j] | i in 1..rows])
);

% Objective
solve satisfy;