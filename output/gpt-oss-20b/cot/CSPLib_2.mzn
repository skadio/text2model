include "globals.mzn";

% Parameters
int: S;
int: t;
int: n;
array[1..n] of int: d;

% Variables
array[1..t, 1..S] of var 1..n: x;
array[1..n] of var int: produced;
var int: surplus;

% Constraints
constraint forall(i in 1..t-1) (
    lex_le(x[i,1..S], x[i+1,1..S])
);

constraint forall(j in 1..n) (
    produced[j] = sum(i in 1..t, k in 1..S) (bool2int(x[i,k] == j))
);

constraint forall(j in 1..n) (
    produced[j] >= d[j]
);

constraint forall(j in 1..n) (
    produced[j] <= t*S
);

constraint surplus = sum(j in 1..n) (produced[j] - d[j]);

% Objective
solve minimize surplus;