include "globals.mzn";

/*
  Balanced Incomplete Block Design (BIBD)

  Parameters (from .dzn):
    v      number of objects (points)
    b      number of blocks
    r      number of blocks each object occurs in
    k      number of objects per block
    lambda number of blocks each pair of objects occurs together in
*/

int: v;
int: b;
int: r;
int: k;
int: lambda;

/* Incidence matrix: x[i,j] = 1 iff object i is in block j */
array[1..v, 1..b] of var 0..1: x;

% Each object appears in exactly r blocks
constraint forall(i in 1..v)(
  count([x[i,j] | j in 1..b], 1, r)
);

% Each block contains exactly k objects
constraint forall(j in 1..b)(
  count([x[i,j] | i in 1..v], 1, k)
);

% Every pair of distinct objects appears together in exactly lambda blocks
constraint forall(i1 in 1..v, i2 in i1+1..v)(
  sum(j in 1..b)(x[i1,j] * x[i2,j]) = lambda
);

% Symmetry breaking: lexicographically non-increasing columns (blocks)
% (helps remove permutations of blocks)
constraint forall(j in 1..b-1)(
  lex_lesseq([x[i,j+1] | i in 1..v], [x[i,j] | i in 1..v])
);

% Additional symmetry breaking: lexicographically non-increasing rows (objects)
% (helps remove permutations of objects)
constraint forall(i in 1..v-1)(
  lex_lesseq([x[i+1,j] | j in 1..b], [x[i,j] | j in 1..b])
);

solve satisfy;

output [
  "x (incidence v x b) =\n",
  concat([ concat([ if fix(x[i,j])=1 then "1 " else "0 " endif | j in 1..b]) ++ "\n"
         | i in 1..v ])
];