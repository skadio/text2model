int: S;
int: t;
int: n;
array[1..n] of int: d;

array[1..t, 1..S] of var 1..n: slot;

constraint
  forall(v in 1..n) (
    sum([bool2int(slot[i,j] == v) | i in 1..t, j in 1..S]) >= d[v]
  );

constraint
  forall(i in 1..t-1) (
    lex_leq([slot[i,j] | j in 1..S], [slot[i+1,j] | j in 1..S])
  );

var int: surplus = sum([sum([bool2int(slot[i,j] == v) | i in 1..t, j in 1..S]) - d[v] | v in 1..n]);

solve minimize surplus;

output [
  "Assignment:\n",
  concat([ "Template " ++ show(i) ++ ": " ++ show([slot[i,j] | j in 1..S]) ++ "\n" | i in 1..t]),
  "Surplus: " ++ show(surplus) ++ "\n"
];