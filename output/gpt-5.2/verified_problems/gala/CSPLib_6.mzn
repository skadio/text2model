include "globals.mzn";

int: m;                       % number of marks (given in .dzn)

% Decision variables: mark positions
array[1..m] of var 0..ub: a;
var 0..ub: L;

% Differences between marks (only meaningful for i<j)
array[1..m, 1..m] of var 0..ub: d;

% Basic structure
constraint a[1] = 0;
constraint a[m] = L;
constraint increasing(a);

% Define differences
constraint forall(i,j in 1..m where i < j)(
  d[i,j] = a[j] - a[i]
);

% All pairwise differences must be distinct
constraint all_different([ d[i,j] | i,j in 1..m where i < j ]);

% Symmetry breaking: first gap smaller than last gap
constraint a[2] - a[1] < a[m] - a[m-1];

solve minimize L;

output [
  "m = ", show(m), "\n",
  "L = ", show(L), "\n",
  "a = ", show(a), "\n"
];

% Upper bound for the ruler length (safe default if not provided)
function int: ub =
  if m <= 1 then 0
  else (m*(m-1) div 2) * (m*(m-1) div 2)
  endif;