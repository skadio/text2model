include "globals.mzn";

int: m;                      % number of marks on the Golomb ruler
int: max_len = m*m;          % an upper bound for the ruler's length

% Marks on the Golomb ruler: a[1] is fixed at 0; a[m] is the ruler's length
array[1..m] of var 0..max_len: a;

% Each difference between two marks must be unique.
array[1..(m*(m-1)) div 2] of var 1..max_len: diffs = [ a[j] - a[i] | i, j in 1..m where i < j ];

constraint a[1] = 0;
constraint increasing(a);            % ensures 0 = a[1] < a[2] < ... < a[m]
constraint all_different(diffs);
constraint a[2] - a[1] < a[m] - a[m-1];  % symmetry breaking constraint

solve minimize a[m];

output [
  "Golomb ruler marks: ", show(a), "\n",
  "Length: ", show(a[m]), "\n"
];