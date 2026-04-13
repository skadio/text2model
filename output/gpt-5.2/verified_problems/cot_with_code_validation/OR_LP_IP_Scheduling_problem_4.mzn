% Parameters
int: n;
array[1..n, 1..n] of int: huts;

set of int: R = 1..n;
set of int: C = 1..n;

int: K = 2;

% Variables: exactly K drop locations
array[1..K] of var R: drop_r;
array[1..K] of var C: drop_c;

% Squared distance to nearest drop for each cell
array[R, C] of var 0..2*(n-1)*(n-1): mindist2;

% Constraints
constraint forall(r in R, c in C) (huts[r,c] >= 0);

constraint forall(r in R, c in C) (
  mindist2[r,c] =
    min([ (r - drop_r[k])*(r - drop_r[k]) + (c - drop_c[k])*(c - drop_c[k])
          | k in 1..K ])
);

% Objective: weighted sum by number of huts at each cell
solve minimize sum(r in R, c in C) (huts[r,c] * mindist2[r,c]);