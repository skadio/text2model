include "globals.mzn";

int: m;

set of int: MARKS = 1..m;
set of int: DIFFIDX = 1..(m*(m-1) div 2);

array[MARKS] of var int: a;

constraint a[1] = 0;
constraint increasing(a);

var int: L = a[m];
constraint L >= 0;

array[DIFFIDX] of var int: d;

constraint
  let {
    array[DIFFIDX] of var int: tmp =
      [ a[j] - a[i] | i in 1..m-1, j in i+1..m ]
  } in
    forall(k in DIFFIDX)(d[k] = tmp[k]);

constraint forall(k in DIFFIDX)(d[k] > 0);
constraint all_different(d);

% Symmetry breaking: first gap < last gap
constraint a[2] - a[1] < a[m] - a[m-1];

solve minimize L;

output [
  "length = ", show(L), "\n",
  "marks  = ", show(a), "\n"
];