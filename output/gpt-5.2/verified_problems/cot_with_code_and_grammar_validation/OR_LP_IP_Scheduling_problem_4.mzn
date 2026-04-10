% Parameters
int: n;
array[1..n, 1..n] of int: huts;

set of int: R = 1..n;
set of int: C = 1..n;

int: maxDist2 = 2*(n-1)*(n-1);
int: totalHuts = sum(r in R, c in C)(huts[r,c]);

% Variables
array[1..2] of var R: drop_r;
array[1..2] of var C: drop_c;

array[R, C] of var 0..maxDist2: d2;
var 0..(totalHuts*maxDist2): obj;

% Constraints
constraint (drop_r[1] < drop_r[2]) \/ (drop_r[1] = drop_r[2] /\ drop_c[1] < drop_c[2]);

constraint
  forall(r in R, c in C)(
    d2[r,c] = min([ (r - drop_r[k])*(r - drop_r[k]) + (c - drop_c[k])*(c - drop_c[k]) | k in 1..2 ])
  );

constraint
  obj = sum(r in R, c in C)(huts[r,c] * d2[r,c]);

% Objective
solve minimize obj;