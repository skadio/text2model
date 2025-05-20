% Parameters
int: rows;
int: row_rule_len;
array[1..rows, 1..row_rule_len] of int: row_rules;

int: cols;
int: col_rule_len;
array[1..cols, 1..col_rule_len] of int: col_rules;

set of int: Rows = 1..rows;
set of int: Cols = 1..cols;
set of int: RowRules = 1..row_rule_len;
set of int: ColRules = 1..col_rule_len;

% Variables
array[Rows, Cols] of var 0..1: cell;

array[Rows, RowRules] of var 1..cols: row_start;
array[Cols, ColRules] of var 1..rows: col_start;

% Constraints

% Row blocks fit within the grid
constraint
  forall(r in Rows, k in RowRules where row_rules[r,k] > 0)(
    row_start[r,k] + row_rules[r,k] - 1 <= cols
  );

% Row blocks are ordered and separated by at least one blank square
constraint
  forall(r in Rows, k in 1..row_rule_len-1
         where row_rules[r,k] > 0 /\ row_rules[r,k+1] > 0)(
    row_start[r,k+1] >= row_start[r,k] + row_rules[r,k] + 1
  );

% Column blocks fit within the grid
constraint
  forall(c in Cols, k in ColRules where col_rules[c,k] > 0)(
    col_start[c,k] + col_rules[c,k] - 1 <= rows
  );

% Column blocks are ordered and separated by at least one blank square
constraint
  forall(c in Cols, k in 1..col_rule_len-1
         where col_rules[c,k] > 0 /\ col_rules[c,k+1] > 0)(
    col_start[c,k+1] >= col_start[c,k] + col_rules[c,k] + 1
  );

% Link row starts to shaded cells
constraint
  forall(r in Rows, c in Cols)(
    cell[r,c] =
      bool2int(
        or([ row_rules[r,k] > 0 /\
             row_start[r,k] <= c /\ c <= row_start[r,k] + row_rules[r,k] - 1
             | k in RowRules ])
      )
  );

% Link column starts to shaded cells (consistency)
constraint
  forall(r in Rows, c in Cols)(
    cell[r,c] =
      bool2int(
        or([ col_rules[c,k] > 0 /\
             col_start[c,k] <= r /\ r <= col_start[c,k] + col_rules[c,k] - 1
             | k in ColRules ])
      )
  );

% Objective
solve satisfy;