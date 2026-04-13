% Parameters
int: n = 2;
set of int: F = 1..n;  % factories
set of int: L = 1..n;  % locations

array[F, L] of int: d = array2d(F, L, [
  10, 20,
  30, 40
]);

array[L, L] of int: c = array2d(L, L, [
  5, 8,
  6, 7
]);

% Variables
array[F, L] of var 0..1: x; % x[i,p]=1 if factory i assigned to location p

% Constraints
constraint
  forall(i in F) (
    sum(p in L)(x[i,p]) = 1
  );

constraint
  forall(p in L) (
    sum(i in F)(x[i,p]) = 1
  );

% Objective
var int: total_cost =
  sum(i in F, j in F, p in L, q in L) (d[i,j] * c[p,q] * x[i,p] * x[j,q]);

solve minimize total_cost;