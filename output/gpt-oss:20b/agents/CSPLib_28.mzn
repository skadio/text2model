include "globals.mzn";

/* ---------- Problem data (provided via a .dzn file) ---------- */
int: v;                     % number of distinct objects
int: b;                     % number of blocks
int: k;                     % objects per block
int: lambda;                % pair frequency
array[1..v] of int: r;      % occurrences of each object (r[i] times)

/* ---------- Decision variables ---------- */
array[1..b,1..k] of var 1..v: block;

/* ---------- Constraints ---------- */

/* 1. Every block contains distinct objects */
constraint forall(i in 1..b)(
  all_different([block[i,j] | j in 1..k])
);

/* 2. Each object i appears exactly r[i] times in all blocks */
constraint forall(i in 1..v)(
  count([block[i',j] | i' in 1..b, j in 1..k], i, r[i])
);

/* 3. Every unordered pair of distinct objects appears together lambda times */
constraint forall(i in 1..v, j in i+1..v)(
  lambda == sum(bIdx in 1..b)(
    bool2int(count([block[bIdx,p] | p in 1..k], i, 1) >= 1) *
    bool2int(count([block[bIdx,p] | p in 1..k], j, 1) >= 1)
  )
);

/* 4. Basic sanity checks (optional) */
constraint sum(i in 1..v)(r[i]) = b * k;

/* ---------- Solve ---------- */
solve satisfy;

/* ---------- Output ---------- */
output [
  "Blocks:\n",
  concat([ show(i) ^ ": " ^ show([block[i,j] | j in 1..k]) ^ "\n" | i in 1..b ])
];