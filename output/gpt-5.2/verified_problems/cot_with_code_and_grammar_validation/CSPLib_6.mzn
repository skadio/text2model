include "globals.mzn";

int: m;

int: ub = (m * (m - 1)) div 2;
int: nd = (m * (m - 1)) div 2;

array[1..m] of var 0..ub: a;
var 0..ub: L;
array[1..nd] of var 1..ub: d;

constraint a[1] = 0;
constraint a[m] = L;

constraint forall(i in 1..m-1) (a[i] < a[i+1]);

constraint if m >= 3 then a[2] - a[1] < a[m] - a[m-1] else true endif;

constraint
  let {
    array[1..nd] of int: I = [ i | i in 1..m-1, j in i+1..m ],
    array[1..nd] of int: J = [ j | i in 1..m-1, j in i+1..m ]
  } in
  forall(k in 1..nd) (
    d[k] = a[J[k]] - a[I[k]]
  );

constraint all_different(d);

solve minimize L;