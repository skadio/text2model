% Parameters
int: n = 4;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  [|  0, 61, 17, 81
   | 61,  0, 40, 52
   | 17, 40,  0, 23
   | 81, 52, 23,  0 |];

% Variables
array[CITIES, CITIES] of var 0..1: x;           % x[i,j]=1 if travel from i to j
array[CITIES] of var 0..n-1: u;                 % MTZ order variables
var 0..sum(i in CITIES, j in CITIES)(cost[i,j]): total_cost;

% Constraints
constraint forall(i in CITIES)(x[i,i] = 0);

% Exactly one outgoing and one incoming arc per city
constraint forall(i in CITIES)(
  sum(j in CITIES)(x[i,j]) = 1
);
constraint forall(j in CITIES)(
  sum(i in CITIES)(x[i,j]) = 1
);

% MTZ subtour elimination (fix u[1]=0 as reference)
constraint u[1] = 0;
constraint forall(i in 2..n)(u[i] >= 1 /\ u[i] <= n-1);

constraint forall(i in 2..n, j in 2..n where i != j)(
  u[i] - u[j] + (n-1) * x[i,j] <= n-2
);

% Total cost
constraint total_cost = sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;