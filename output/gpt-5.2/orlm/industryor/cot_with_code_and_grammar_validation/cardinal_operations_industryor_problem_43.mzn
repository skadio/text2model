% Transshipment transportation with fixed station opening costs

% Parameters
int: m = 2;
int: n = 2;
int: p = 2;

set of int: I = 1..m;
set of int: J = 1..n;
set of int: K = 1..p;

array[I] of int: a = [100, 150];
array[J] of int: b = [80, 120];

array[K] of int: f = [10, 15];
array[K] of int: q = [100, 100];

array[I, K] of int: c = array2d(I, K, [
  2, 3,
  4, 1
]);

array[K, J] of int: cp = array2d(K, J, [
  3, 2,
  1, 4
]);

% Variables
array[I, K] of var 0..max(a): x;   % shipped from production i to station k
array[K, J] of var 0..max(b): y;   % shipped from station k to demand j
array[K] of var bool: use;         % true if station k is used

% Constraints

% production limits
constraint forall(i in I) (
  sum(k in K)(x[i,k]) <= a[i]
);

% demand satisfaction
constraint forall(j in J) (
  sum(k in K)(y[k,j]) = b[j]
);

% flow conservation at each station
constraint forall(k in K) (
  sum(i in I)(x[i,k]) = sum(j in J)(y[k,j])
);

% station capacity and activation
constraint forall(k in K) (
  sum(i in I)(x[i,k]) <= q[k]
);

constraint forall(k in K) (
  sum(i in I)(x[i,k]) <= q[k] * bool2int(use[k])
);

% Objective (minimization)
solve minimize
  sum(i in I, k in K)(c[i,k] * x[i,k]) +
  sum(k in K, j in J)(cp[k,j] * y[k,j]) +
  sum(k in K)(f[k] * bool2int(use[k]));

output [
  "Total cost = ", show(
    sum(i in I, k in K)(c[i,k] * x[i,k]) +
    sum(k in K, j in J)(cp[k,j] * y[k,j]) +
    sum(k in K)(f[k] * bool2int(use[k]))
  ), "\n",
  "use = ", show([bool2int(use[k]) | k in K]), "\n",
  "x =\n", show2d(x), "\n",
  "y =\n", show2d(y), "\n"
];