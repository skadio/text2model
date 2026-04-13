% Parameters
int: n = 2;
set of int: F = 1..n;
set of int: L = 1..n;

% d[i,j]: transportation volume between factory i and factory j (given as table)
array[F, L] of int: d =
  [| 10, 20
   | 30, 40 |];

% c[p,q]: unit transportation cost from location p to location q
array[L, L] of int: c =
  [| 5, 8
   | 6, 7 |];

% Decision variables: loc[i] is the location assigned to factory i
array[F] of var L: loc;

% Each factory assigned to a different location
constraint alldifferent(loc);

% Objective: minimize total transportation cost
var int: total_cost =
  sum(i in F, j in L) (d[i,j] * c[loc[i], j]);

solve minimize total_cost;