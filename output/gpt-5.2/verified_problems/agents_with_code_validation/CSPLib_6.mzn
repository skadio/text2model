include "globals.mzn";

% Parameters
int: m;                         % Number of marks on the Golomb ruler (provided in .dzn)
set of int: MARKS = 1..m;       % Index set for marks

% Variables
var 0..1000000: L;              % Length of the ruler (i.e., a[m]) - wide upper bound

array[MARKS] of var 0..1000000: a;   % Positions of marks along the ruler (0 = a[1] < ... < a[m] = L)

% Pair index sets (for differences)
set of int: I = 1..m-1;                             % First index in a pair
array[I] of set of int: J = [i+1..m | i in I];      % Second index range for each i (j > i)

array[I, MARKS] of var 0..1000000: d;               % Differences d[i,j] = a[j] - a[i] (only meaningful for j in J[i])

% Constraints

% --- Mark positions: strict increase, endpoints fixed, and link to length ---
constraint a[1] = 0;
constraint a[m] = L;
constraint forall(i in 1..m-1) (a[i] < a[i+1]);

% --- Define pairwise differences d[i,j] = a[j] - a[i] for valid pairs (i<j) ---
constraint forall(i in I, j in J[i]) (
  d[i,j] = a[j] - a[i]
);

% --- All differences must be distinct (Golomb property) ---
constraint all_different([ d[i,j] | i in I, j in J[i] ]);

% --- Symmetry breaking: first gap smaller than last gap ---
constraint a[2] - a[1] < a[m] - a[m-1];

% Objective
solve minimize L;