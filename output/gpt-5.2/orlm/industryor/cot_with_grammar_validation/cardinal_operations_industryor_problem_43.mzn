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

array[K, J] of int: c2 = array2d(K, J, [
  3, 2,
  1, 4
]);

int: totalSupply = sum(i in I)(a[i]);
int: totalDemand = sum(j in J)(b[j]);

% Variables
array[I, K, J] of var 0..max(a): x;     % flow i -> k -> j
array[K] of var bool: y;                % 1 if station k is used

% Constraints
constraint totalSupply >= totalDemand;

constraint
  forall(i in I)(
    sum(k in K, j in J)(x[i,k,j]) <= a[i]
  );

constraint
  forall(j in J)(
    sum(i in I, k in K)(x[i,k,j]) = b[j]
  );

constraint
  forall(k in K)(
    sum(i in I, j in J)(x[i,k,j]) <= q[k]
  );

constraint
  forall(k in K)(
    sum(i in I, j in J)(x[i,k,j]) <= q[k] * bool2int(y[k])
  );

% Objective
solve minimize
  sum(k in K)(f[k] * bool2int(y[k]))
  + sum(i in I, k in K, j in J)((c[i,k] + c2[k,j]) * x[i,k,j]);