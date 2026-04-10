% Parameters
int: n;
array[1..n] of int: a;
int: k;

% Variables
array[1..n] of var 1..k: g;
array[1..k] of var int: s;
var int: maxSum;

% Constraints
constraint forall(j in 1..k) (
  s[j] = sum(i in 1..n)(a[i] * bool2int(g[i] = j))
);

constraint maxSum = max(j in 1..k)(s[j]);

% Objective
solve minimize maxSum;