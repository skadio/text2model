int: rows;
int: cols;

int: row_rule_len;
int: col_rule_len;

array[1..rows, 1..row_rule_len] of int: row_rules;
array[1..cols, 1..col_rule_len] of int: col_rules;

array[1..rows, 1..cols] of var bool: x; % true = shaded

function int: posMax(int: n, int: len) = n - len + 1;

predicate line_blocks(array[int] of var bool: line, array[int] of int: rules) =
  let {
    int: n = length(line);
    int: k = length(rules);
    array[1..k] of int: r = rules;

    array[1..k] of var 1..n: s; % start positions (may be arbitrary if r[i]=0)

    array[1..n] of var 0..k: blk; % block index per cell (0 = white)
  } in
  (
    % start positions bounds and ordering (only enforced for positive rules)
    forall(i in 1..k) (
      (r[i] > 0) -> (s[i] <= posMax(n, r[i]))
    )
    /\
    forall(i in 1..k-1) (
      (r[i] > 0 /\ r[i+1] > 0) -> (s[i] + r[i] < s[i+1])
    )
    /\
    % blk variable domain coherence with rules
    forall(j in 1..n) (
      (blk[j] = 0) <-> (not line[j])
    )
    /\
    forall(j in 1..n) (
      (blk[j] > 0) <-> line[j]
    )
    /\
    % every shaded cell belongs to exactly one positive-length block
    forall(j in 1..n) (
      line[j] ->
      exists(i in 1..k where r[i] > 0) (
        blk[j] = i /\ s[i] <= j /\ j < s[i] + r[i]
      )
    )
    /\
    % cells inside a positive-length block are shaded and assigned that block index
    forall(i in 1..k where r[i] > 0) (
      forall(j in 1..n) (
        (s[i] <= j /\ j < s[i] + r[i]) -> (line[j] /\ blk[j] = i)
      )
    )
    /\
    % blocks are maximal: neighbors are white (if within bounds)
    forall(i in 1..k where r[i] > 0) (
      (s[i] > 1 -> (not line[s[i]-1]))
      /\
      (s[i] + r[i] <= n -> (not line[s[i] + r[i]]))
    )
    /\
    % if a rule is zero, that block index cannot appear
    forall(i in 1..k where r[i] = 0) (
      forall(j in 1..n) (blk[j] != i)
    )
  );

constraint
  forall(r in 1..rows) (
    line_blocks([x[r,c] | c in 1..cols], [row_rules[r,i] | i in 1..row_rule_len])
  )
  /\
  forall(c in 1..cols) (
    line_blocks([x[r,c] | r in 1..rows], [col_rules[c,i] | i in 1..col_rule_len])
  );

solve satisfy;

output [
  if c=1 then "" else "" endif ++
  (if fix(x[r,c]) then "#" else "." endif) ++
  (if c=cols then "\n" else "" endif)
  | r in 1..rows, c in 1..cols
];