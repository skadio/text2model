% Parameters
int: n;
array[1..n, 1..n] of int: huts;

set of int: R = 1..n;
set of int: C = 1..n;

% Variables
var R: drop1_r;
var C: drop1_c;
var R: drop2_r;
var C: drop2_c;

% Constraints
constraint (drop1_r != drop2_r) \/ (drop1_c != drop2_c);

% Objective
solve minimize
  sum(r in R, c in C where huts[r,c] > 0)(
    huts[r,c] * min(
      (r - drop1_r)*(r - drop1_r) + (c - drop1_c)*(c - drop1_c),
      (r - drop2_r)*(r - drop2_r) + (c - drop2_c)*(c - drop2_c)
    )
  );