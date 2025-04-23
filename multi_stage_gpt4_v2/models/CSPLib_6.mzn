% Parameters
int: m; % Number of marks on the Golomb ruler

% Variables
array[1..m] of var 0..m*m: a; % Array of integers representing the marks on the Golomb ruler
var 0..m*m: length; % Length of the Golomb ruler

% Constraints

% The marks on the ruler are in increasing order
constraint forall(i in 1..m-1) (
  a[i] < a[i+1]
);

% The differences between all pairs of marks are distinct
constraint forall(i in 1..m-1, j in i+1..m) (
  forall(k in 1..m-1, l in k+1..m) (
    if i != k \/ j != l then
      abs(a[j] - a[i]) != abs(a[l] - a[k])
    else
      true
    endif
  )
);

% The length of the ruler is the last mark
constraint length = a[m];

% The first difference is less than the last
constraint a[2] - a[1] < a[m] - a[m-1];

% Objective
solve minimize length;