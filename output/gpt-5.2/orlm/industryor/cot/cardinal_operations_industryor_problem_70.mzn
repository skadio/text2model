% Parameters (with values embedded)
int: n = 2;
set of int: F = 1..n;        % factories
set of int: L = 1..n;        % locations

% Transportation volume d[i,j] between factory i and factory j
array[F,F] of int: d =
[| 10, 20
 | 30, 40 |];

% Unit transportation cost c[p,q] from location p to location q
array[L,L] of int: c =
[| 5, 8
 | 6, 7 |];

% Variables
% x[i,p] = 1 if factory i is assigned to location p
array[F,L] of var 0..1: x;

% Constraints
constraint forall(i in F) (
  sum(p in L)(x[i,p]) = 1
);
constraint forall(p in L) (
  sum(i in F)(x[i,p]) = 1
);

% Objective
var int: total_cost =
  sum(i in F, j in F, p in L, q in L) (d[i,j] * c[p,q] * x[i,p] * x[j,q]);

solve minimize total_cost;