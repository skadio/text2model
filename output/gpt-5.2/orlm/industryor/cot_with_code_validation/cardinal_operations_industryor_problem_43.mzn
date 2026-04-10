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

array[I, K] of int: c = array2d(I, K,
  [ 2, 3,
    4, 1
  ]);

array[K, J] of int: c2 = array2d(K, J,
  [ 3, 2,
    1, 4
  ]);

% Variables
array[I, K, J] of var 0..max(q): x;     % flow from i to j via k
array[K] of var 0..1: y;                % 1 if station k is used

var int: total_cost;

% Constraints
constraint forall(i in I)(
  sum(k in K, j in J)(x[i,k,j]) <= a[i]
);

constraint forall(j in J)(
  sum(i in I, k in K)(x[i,k,j]) = b[j]
);

constraint forall(k in K)(
  sum(i in I, j in J)(x[i,k,j]) <= q[k]
);

constraint forall(k in K)(
  sum(i in I, j in J)(x[i,k,j]) <= q[k] * y[k]
);

constraint total_cost =
  sum(i in I, k in K, j in J)((c[i,k] + c2[k,j]) * x[i,k,j])
  + sum(k in K)(f[k] * y[k]);

% Objective
solve minimize total_cost;