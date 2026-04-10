include "globals.mzn";

int: m;

% Decision variables: mark positions
array[1..m] of var int: a;

% Fix first mark at 0 and enforce strictly increasing marks
constraint a[1] = 0;
constraint forall(i in 1..m-1)(a[i] < a[i+1]);

% Differences between all pairs of marks must be distinct
int: numDiff = m*(m-1) div 2;
array[1..numDiff] of var int: d;

constraint
  let {
    array[1..numDiff] of int: I = [ i | i in 1..m-1, j in i+1..m ],
    array[1..numDiff] of int: J = [ j | i in 1..m-1, j in i+1..m ]
  } in
  forall(k in 1..numDiff)(
    d[k] = a[J[k]] - a[I[k]]
  );

constraint all_different(d);

% Symmetry breaking: first gap smaller than last gap
constraint a[2] - a[1] < a[m] - a[m-1];

% Objective: minimize ruler length
solve minimize a[m];

output [
  "length = ", show(a[m]), "\n",
  "a = ", show(a), "\n"
];