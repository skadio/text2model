include "globals.mzn";

% Parameters
int: m;

% Derived constants
int: nDiff = (m * (m - 1)) div 2;

% Variables
array[1..m] of var 0..ub: a;
var 0..ub: L;
array[1..nDiff] of var 1..ub: d;

% Upper bound (simple safe bound)
int: ub = m * m;

% Constraints
constraint a[1] = 0;
constraint increasing(a);
constraint L = a[m];

% Symmetry breaking: first gap < last gap (only meaningful for m >= 3)
constraint if m >= 3 then (a[2] - a[1]) < (a[m] - a[m-1]) else true endif;

% Pairwise differences
constraint
  let {
    array[1..nDiff] of int: I = [ i | i in 1..m-1, j in i+1..m ],
    array[1..nDiff] of int: J = [ j | i in 1..m-1, j in i+1..m ]
  } in
  forall(k in 1..nDiff) (
    d[k] = a[J[k]] - a[I[k]] /\
    d[k] >= 1 /\
    d[k] <= L
  );

constraint all_different(d);

% Objective
solve minimize L;

output [
  "L = ", show(L), "\n",
  "a = ", show(a), "\n"
];