% Parameters
int: n = 2;                                  % number of factories and locations (equal)
set of int: F = 1..n;                        % factories index set
set of int: L = 1..n;                        % locations index set

array[F, L] of int: d =                      % transportation volume from factory i to location j (given table)
  [| 10, 20
   | 30, 40 |];

array[L, L] of int: c =                      % unit transportation cost from location p to location q (given table)
  [| 5, 8
   | 6, 7 |];

% Variables
array[F, L] of var 0..1: x;                  % x[i,l]=1 if factory i is assigned to location l, else 0
var int: total_cost;                         % total transportation cost (objective value)

% Constraints

%------------------------------------------------------------
% Assignment constraints: each factory is assigned to exactly one location
%------------------------------------------------------------
constraint
  forall(i in F) (
    sum(l in L)(x[i, l]) = 1
  );

%------------------------------------------------------------
% Assignment constraints: each location hosts exactly one factory
%------------------------------------------------------------
constraint
  forall(l in L) (
    sum(i in F)(x[i, l]) = 1
  );

%------------------------------------------------------------
% Total transportation cost definition:
% cost = sum over factory pairs (i,j) and location pairs (p,q)
%        d[i,j] * c[p,q] * x[i,p] * x[j,q]
% Note: For n=2 this quadratic form is fine; in larger instances you might
%       linearize or use specialized QAP modeling approaches.
%------------------------------------------------------------
constraint
  total_cost =
    sum(i in F, j in F, p in L, q in L) (
      d[i, j] * c[p, q] * x[i, p] * x[j, q]
    );

% Objective
solve minimize total_cost;