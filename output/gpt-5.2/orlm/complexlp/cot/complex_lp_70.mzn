% Parameters (with values embedded)
int: N = 4;
set of int: CITIES = 1..N;

array[CITIES, CITIES] of int: cost =
[|  0, 61, 17, 81
 | 61,  0, 40, 52
 | 17, 40,  0, 23
 | 81, 52, 23,  0
 |];

% Variables
array[CITIES, CITIES] of var 0..1: x;          % x[i,j] = 1 if travel i -> j
array[CITIES] of var 1..N: u;                  % MTZ ordering variables

% Constraints
% No self loops
constraint forall(i in CITIES)(x[i,i] = 0);

% Exactly one outgoing arc from each city
constraint forall(i in CITIES)(
  sum(j in CITIES)(x[i,j]) = 1
);

% Exactly one incoming arc to each city
constraint forall(j in CITIES)(
  sum(i in CITIES)(x[i,j]) = 1
);

% MTZ subtour elimination (fix u[1] = 1, others in 2..N)
constraint u[1] = 1;
constraint forall(i in 2..N)(u[i] >= 2 /\ u[i] <= N);

constraint forall(i in 2..N, j in 2..N where i != j)(
  u[i] - u[j] + N * x[i,j] <= N - 1
);

% Objective
var int: total_cost = sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

solve minimize total_cost;