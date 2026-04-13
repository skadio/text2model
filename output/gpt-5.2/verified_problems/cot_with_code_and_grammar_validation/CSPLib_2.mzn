include "globals.mzn";

int: S;
int: t;
int: n;
array[1..n] of int: d;

int: maxSheets = max(d);

array[1..t, 1..S] of var 1..n: slot;
array[1..t, 1..n] of var 0..S: cnt;
array[1..t] of var 0..maxSheets: sheets;

array[1..n] of var 0..(maxSheets*t*S): prod;
array[1..n] of var 0..(maxSheets*t*S): surplus_v;
var 0..(maxSheets*t*S*n): surplus;

constraint forall(k in 1..t, v in 1..n) (
  cnt[k,v] = sum(s in 1..S)(bool2int(slot[k,s] = v))
);

constraint forall(v in 1..n) (
  prod[v] = sum(k in 1..t)(sheets[k] * cnt[k,v])
);

constraint forall(v in 1..n) (
  prod[v] >= d[v]
);

constraint forall(v in 1..n) (
  surplus_v[v] = prod[v] - d[v]
);

constraint surplus = sum(v in 1..n)(surplus_v[v]);

constraint forall(k in 1..t-1) (
  lex_lesseq([slot[k,s] | s in 1..S], [slot[k+1,s] | s in 1..S])
);

solve minimize surplus;

output [
  "surplus=", show(surplus), "\n",
  "sheets=", show(sheets), "\n",
  "slot=\n", show(slot), "\n",
  "cnt=\n", show(cnt), "\n",
  "prod=", show(prod), "\n",
  "surplus_v=", show(surplus_v), "\n"
];