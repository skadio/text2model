% Parameters (with values embedded)
int: n = 4;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: dist =
[
|  0, 10, 20, 12,
| 10,  0,  5, 10,
| 20,  5,  0,  8,
| 15, 12,  8,  0
|];

% Variables
array[CITIES, CITIES] of var 0..1: x;     % x[i,j] = 1 if travel directly from i to j
array[CITIES] of var 1..n: u;             % MTZ ordering variables

% Constraints
% No self-loops
constraint forall(i in CITIES)(x[i,i] = 0);

% Exactly one outgoing arc from each city
constraint forall(i in CITIES)(
  sum(j in CITIES)(x[i,j]) = 1
);

% Exactly one incoming arc to each city
constraint forall(j in CITIES)(
  sum(i in CITIES)(x[i,j]) = 1
);

% Fix start city for symmetry breaking
constraint u[1] = 1;
constraint forall(i in 2..n)(u[i] >= 2 /\ u[i] <= n);

% Subtour elimination (MTZ)
constraint forall(i in 2..n, j in 2..n where i != j)(
  u[i] - u[j] + n * x[i,j] <= n - 1
);

% Objective
var int: total_distance = sum(i in CITIES, j in CITIES)(dist[i,j] * x[i,j]);

solve minimize total_distance;