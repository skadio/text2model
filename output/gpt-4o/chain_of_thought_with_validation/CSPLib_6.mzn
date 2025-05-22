include "globals.mzn";

int: m;                               % number of marks on the Golomb ruler
int: maxLen = m * m;                  % loose upper bound on the ruler length

array[1..m] of var 0..maxLen: a;      % positions of the marks

constraint a[1] = 0;                               % first mark fixed at 0
constraint forall(i in 1..m-1)(a[i] < a[i+1]);     % strictly increasing marks
constraint forall(i in 2..m)(a[i] >= i - 1);       % minimum gap of 1
constraint alldifferent([ a[j] - a[i] | i, j in 1..m where i < j ]);  % unique differences
constraint (a[2] - a[1]) < (a[m] - a[m-1]);        % symmetry breaking

solve minimize a[m];                                % minimise the ruler length