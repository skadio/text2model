% Parameters
int: m; % Number of marks on the Golomb ruler

% Variables
array[1..m] of var 0..m*m: a; % Array of integers representing the marks on the Golomb ruler

% Constraints

% The marks on the ruler are in increasing order
constraint forall(i in 1..m-1) (
  a[i] < a[i+1]
);

% The differences between all pairs of marks are distinct
constraint forall(i in 1..m-1, j in i+1..m) (
  forall(k in 1..m-1, l in k+1..m) (
    if i != k \/ j != l then
      a[j] - a[i] != a[l] - a[k]
    endif
  )
);

% The first difference is less than the last
constraint a[2] - a[1] < a[m] - a[m-1];

% Objective
solve minimize a[m];