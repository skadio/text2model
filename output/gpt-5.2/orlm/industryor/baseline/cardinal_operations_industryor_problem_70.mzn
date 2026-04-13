% Quadratic Assignment Problem (QAP) for n=2 factories and 2 locations
% Data embedded from the table.

int: n = 2;
set of int: F = 1..n;  % factories
set of int: L = 1..n;  % locations

% Transportation volume between factories i and j: d[i,j]
array[F, F] of int: d =
[| 10, 20,
   30, 40 |];

% Unit transportation cost between locations p and q: c[p,q]
array[L, L] of int: c =
[|  5,  8,
    6,  7 |];

% Assignment: x[i,p] = 1 iff factory i is assigned to location p
array[F, L] of var 0..1: x;

% Each factory assigned to exactly one location
constraint forall(i in F) (
  sum(p in L)(x[i,p]) = 1
);

% Each location gets exactly one factory
constraint forall(p in L) (
  sum(i in F)(x[i,p]) = 1
);

% Total transportation cost:
% sum_{i,j} d[i,j] * sum_{p,q} c[p,q] * x[i,p] * x[j,q]
var int: total_cost =
  sum(i in F, j in F, p in L, q in L) (
    d[i,j] * c[p,q] * x[i,p] * x[j,q]
  );

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "assignment (factory -> location):\n",
  concat([ if fix(x[i,p]) = 1 then "Factory " ++ show(i) ++ " -> Location " ++ show(p) ++ "\n" else "" endif
           | i in F, p in L ])
];