% Parameters
int: m;

% Variables
array[1..m] of var 0..m*m: a;

% Constraints
constraint a[1] = 0;
constraint increasing(a);
constraint forall(i in 1..m, j in i+1..m, k in 1..m, l in k+1..m) (
  (i != k \/ j != l) -> (a[j] - a[i] != a[k] - a[l])
);
constraint a[2] - a[1] < a[m] - a[m-1];

% Objective
solve minimize a[m];