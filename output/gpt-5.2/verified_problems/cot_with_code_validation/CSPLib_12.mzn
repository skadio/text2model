include "regular.mzn";

% Parameters
int: rows;
int: cols;

int: row_rule_len;
int: col_rule_len;

array[1..rows, 1..row_rule_len] of int: row_rules;
array[1..cols, 1..col_rule_len] of int: col_rules;

% Variables
array[1..rows, 1..cols] of var 0..1: cell; % 1 = shaded, 0 = empty

% Basic rule sanity (0 can be used as padding)
constraint forall(r in 1..rows, k in 1..row_rule_len) (row_rules[r,k] >= 0);
constraint forall(c in 1..cols, k in 1..col_rule_len) (col_rules[c,k] >= 0);

% If a 0 appears in a rule list, all later entries must be 0 (contiguous padding)
constraint if row_rule_len > 1 then
  forall(r in 1..rows, k in 1..row_rule_len-1) (
    (row_rules[r,k] = 0) -> (row_rules[r,k+1] = 0)
  )
else true endif;

constraint if col_rule_len > 1 then
  forall(c in 1..cols, k in 1..col_rule_len-1) (
    (col_rules[c,k] = 0) -> (col_rules[c,k+1] = 0)
  )
else true endif;

% Row constraints: exact sequence of blocks (lengths given; 0 = no more blocks).
% Blocks must be separated by >= 1 zero; leading/trailing zeros allowed.
constraint
forall(r in 1..rows) (
  let {
    int: K = row_rule_len,
    int: N = cols,
    array[1..K] of int: L = [ row_rules[r,k] | k in 1..K ],

    int: dead = (K+1)*(N+1),
    set of int: States = 0..dead,

    function int: st(int: i, int: j) = i*(N+1) + j,

    int: start = st(0,0),
    set of int: finals = { st(K,0) }
  } in
  let {
    array[States, 0..1] of int: d =
      array2d(States, 0..1,
        [ if s == dead then dead
          else
            let {
              int: i = s div (N+1),
              int: j = s mod (N+1)
            } in
            if x == 1 then
              if i < K /\ L[i+1] > 0 /\ j < L[i+1] then st(i, j+1) else dead endif
            else
              if j == 0 then
                st(i, 0)
              else
                if i < K /\ L[i+1] > 0 /\ j == L[i+1] then st(i+1, 0) else dead endif
              endif
            endif
          endif
          | s in States, x in 0..1
        ])
  } in
  regular([ cell[r,c] | c in 1..cols ], d, start, finals)
);

% Column constraints: exact sequence of blocks (lengths given; 0 = no more blocks).
constraint
forall(c in 1..cols) (
  let {
    int: K = col_rule_len,
    int: N = rows,
    array[1..K] of int: L = [ col_rules[c,k] | k in 1..K ],

    int: dead = (K+1)*(N+1),
    set of int: States = 0..dead,

    function int: st(int: i, int: j) = i*(N+1) + j,

    int: start = st(0,0),
    set of int: finals = { st(K,0) }
  } in
  let {
    array[States, 0..1] of int: d =
      array2d(States, 0..1,
        [ if s == dead then dead
          else
            let {
              int: i = s div (N+1),
              int: j = s mod (N+1)
            } in
            if x == 1 then
              if i < K /\ L[i+1] > 0 /\ j < L[i+1] then st(i, j+1) else dead endif
            else
              if j == 0 then
                st(i, 0)
              else
                if i < K /\ L[i+1] > 0 /\ j == L[i+1] then st(i+1, 0) else dead endif
              endif
            endif
          endif
          | s in States, x in 0..1
        ])
  } in
  regular([ cell[r,c] | r in 1..rows ], d, start, finals)
);

solve satisfy;