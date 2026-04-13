include "alldifferent.mzn";

% Parameters
int: n = 4;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: dist =
  array2d(CITIES, CITIES,
  [ 0, 10, 20, 12,
   10,  0,  5, 10,
   20,  5,  0,  8,
   15, 12,  8,  0 ]);

% Variables
array[CITIES] of var CITIES: succ;
array[CITIES] of var 0..n-1: pos;   % MTZ ordering (pos[1]=0 fixed)
var int: total_dist;

% Constraints
constraint forall(i in CITIES)(succ[i] != i);  % no self-loops
constraint all_different(succ);                % each city has exactly one predecessor

% MTZ subtour elimination
constraint pos[1] = 0;
constraint forall(i in 2..n)(pos[i] >= 1 /\ pos[i] <= n-1);

constraint forall(i in 2..n, j in 2..n where i != j)(
  pos[i] - pos[j] + (n-1) * (if succ[i] = j then 1 else 0 endif) <= n-2
);

% Total distance
constraint total_dist = sum(i in CITIES)(dist[i, succ[i]]);

% Objective
solve minimize total_dist;

output [
  "total_dist=", show(total_dist), "\n",
  "succ=", show(succ), "\n"
];