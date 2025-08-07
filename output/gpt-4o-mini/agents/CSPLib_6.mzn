include "globals.mzn";

int: m;  % Number of marks on the Golomb ruler
int: max_length = 100;  % Define a reasonable maximum length for the ruler
array[1..m] of var 0..max_length: a;  % Array of marks

/* Constraints */
constraint a[1] = 0;  % The first mark is always at 0
constraint increasing(a);  % Ensure the marks are in increasing order
constraint a[2] < a[m];  % Ensure the second mark is greater than the first
constraint a[2] - a[1] < a[m] - a[m-1];  % Symmetry breaking constraint

% Ensure all differences are distinct
constraint all_different([a[j] - a[i] | i in 1..m, j in i+1..m]);

/* Solve & output */
solve minimize a[m];  % Minimize the length of the Golomb ruler
output [ "Golomb ruler marks = ", show(a), "\nLength = ", show(a[m]), "\n" ];