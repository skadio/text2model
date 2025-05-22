int: m;  % number of marks on the Golomb ruler

int: MAX_LEN = m * m;   % simple upper bound on the ruler length

array[1..m] of var 0..MAX_LEN: a;     % positions of the marks (a[1] = 0)

constraint assert(m >= 2, "The Golomb ruler needs at least two marks.");

constraint a[1] = 0;

constraint forall(i in 1..m-1)(a[i] < a[i+1]);  % strictly increasing marks

constraint all_different([ a[j] - a[i] | i in 1..m-1, j in i+1..m ]);  % distinct differences

% Symmetry-breaking: first gap smaller than last gap (only meaningful for m >= 3)
constraint (m < 3) \/ (a[2] - a[1] < a[m] - a[m-1]);

solve minimize a[m];     % minimise the length of the ruler (last mark)