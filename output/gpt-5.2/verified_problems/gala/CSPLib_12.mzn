include "globals.mzn";

% ----- Input -----
int: rows;
int: cols;

int: row_rule_len;
array[1..rows, 1..row_rule_len] of int: row_rules; % 0 can be used as padding

int: col_rule_len;
array[1..cols, 1..col_rule_len] of int: col_rules; % 0 can be used as padding

% ----- Decision variables -----
array[1..rows, 1..cols] of var 0..1: x;  % 1 = shaded, 0 = empty

% ----- Helper predicate: enforce a line (row/col) matches its block rules -----
predicate line_matches_rules(array[int] of var 0..1: line,
                             array[int] of int: rules) =
let {
  int: N = length(line),
  int: K = length(rules),

  % number of actual blocks (ignore trailing zeros)
  var 0..K: kEff,

  % start positions for each potential block (1..N), unused ones can be 1
  array[1..K] of var 1..N: s
} in
  % kEff is the count of positive rule entries
  kEff = sum(i in 1..K)(bool2int(rules[i] > 0)) /\
  % all positive rules must be in the prefix 1..kEff; suffix must be zeros
  forall(i in 1..K)(
    (i <= kEff -> rules[i] > 0) /\
    (i >  kEff -> rules[i] = 0)
  ) /\
  % starts are strictly increasing with required separation between consecutive blocks
  forall(i in 1..K-1)(
    i < kEff ->
      s[i+1] >= s[i] + rules[i] + 1
  ) /\
  % each used block must fit in the line
  forall(i in 1..K)(
    i <= kEff -> s[i] + rules[i] - 1 <= N
  ) /\
  % unused starts can be arbitrary (kept within domain)
  forall(i in 1..K)( i > kEff -> s[i] = 1 ) /\
  % cell coverage: a cell is shaded iff it belongs to one of the used blocks
  forall(p in 1..N)(
    line[p] = bool2int( exists(i in 1..K)(
                          i <= kEff /\
                          p >= s[i] /\
                          p <= s[i] + rules[i] - 1
                        ))
  );

% ----- Row constraints -----
constraint
  forall(r in 1..rows)(
    line_matches_rules([ x[r,c] | c in 1..cols ],
                       [ row_rules[r,i] | i in 1..row_rule_len ])
  );

% ----- Column constraints -----
constraint
  forall(c in 1..cols)(
    line_matches_rules([ x[r,c] | r in 1..rows ],
                       [ col_rules[c,i] | i in 1..col_rule_len ])
  );

solve satisfy;

output [
  "Grid (1=shaded,0=empty):\n"
] ++
[
  concat([ if fix(x[r,c]) = 1 then "#" else "." endif | c in 1..cols ]) ++ "\n"
  | r in 1..rows
];