% Parameters
int: n = 2;                              % number of factories/locations
set of int: F = 1..n;                    % factories index set
set of int: L = 1..n;                    % locations index set

array[F, L] of int: d =                  % transportation volume from factory i to (destination) factory j (given as table)
  [| 10, 20
   | 30, 40 |];

array[L, L] of int: c =                  % unit transportation cost from location p to location q
  [| 5,  8
   | 6,  7 |];

% Variables
array[F, L] of var 0..1: x;              % x[i,l] = 1 if factory i is assigned to location l, else 0
var int: total_cost;                     % objective value (total transportation cost)

% Constraints

% Assignment constraints: each factory is assigned to exactly one location
constraint
  forall(i in F) (
    sum(l in L)(x[i,l]) = 1
  );

% Assignment constraints: each location hosts exactly one factory (bijective assignment)
constraint
  forall(l in L) (
    sum(i in F)(x[i,l]) = 1
  );

% Cost computation: total transportation cost induced by the assignment
% If factory i is placed at location p and factory j is placed at location q,
% then flow d[i,j] incurs unit cost c[p,q].
constraint
  total_cost =
    sum(i in F, j in F, p in L, q in L)(
      d[i,j] * c[p,q] * x[i,p] * x[j,q]
    );

% Objective
solve minimize total_cost;