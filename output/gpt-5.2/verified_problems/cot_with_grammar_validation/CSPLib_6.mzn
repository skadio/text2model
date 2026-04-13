include "alldifferent.mzn";

int: m;

array[1..m] of var int: a;
var int: L;

constraint a[1] = 0;
constraint forall(i in 1..m-1)(a[i] < a[i+1]);

constraint L = a[m];
constraint L >= 0;

constraint a[2] - a[1] < a[m] - a[m-1];

int: numDiff = m * (m - 1) div 2;
array[1..numDiff] of var int: d;

constraint forall(k in 1..numDiff)(d[k] >= 1 /\ d[k] <= L);

constraint
  let {
    array[1..numDiff] of int: ii = [ i | i in 1..m-1, j in i+1..m ],
    array[1..numDiff] of int: jj = [ j | i in 1..m-1, j in i+1..m ]
  } in
    forall(k in 1..numDiff)(d[k] = a[jj[k]] - a[ii[k]]);

constraint alldifferent(d);

solve minimize L;