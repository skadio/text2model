include "alldifferent.mzn";

% Parameters
int: n = 7;
set of int: LOC = 1..n;

% symmetric distance matrix (0 on diagonal)
array[LOC, LOC] of int: dist =
  [|  0, 86, 49, 57, 31, 69, 50
   | 86,  0, 68, 79, 93, 24,  5
   | 49, 68,  0, 16,  7, 72, 67
   | 57, 79, 16,  0, 90, 69,  1
   | 31, 93,  7, 90,  0, 86, 59
   | 69, 24, 72, 69, 86,  0, 81
   | 50,  5, 67,  1, 59, 81,  0 |];

int: depot = 1;

% Variables
array[LOC] of var LOC: succ;        % succ[i] = next location after i
array[LOC] of var 0..n-1: u;        % MTZ order variables
var 0..sum(i in LOC, j in LOC)(dist[i,j]): total_distance;

% Constraints

% no self-loops
constraint forall(i in LOC) (succ[i] != i);

% succ is a permutation (one outgoing and one incoming for each node)
constraint alldifferent(succ);

% MTZ: depot fixed
constraint u[depot] = 0;

% bounds for non-depot nodes
constraint forall(i in LOC where i != depot) (u[i] >= 1 /\ u[i] <= n-1);

% MTZ subtour elimination
constraint forall(i in LOC where i != depot) (
  forall(j in LOC where j != depot /\ j != i) (
    u[i] - u[j] + (n-1) * bool2int(succ[i] == j) <= n-2
  )
);

% total distance
constraint total_distance = sum(i in LOC)(dist[i, succ[i]]);

solve minimize total_distance;

output [
  "total_distance = ", show(total_distance), "\n",
  "succ = ", show(succ), "\n"
];