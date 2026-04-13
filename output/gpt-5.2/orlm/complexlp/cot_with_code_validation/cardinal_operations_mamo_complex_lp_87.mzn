% Parameters
int: n = 5;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  [|  0, 46, 63, 54, 45
   | 46,  0, 48, 50, 51
   | 63, 48,  0, 31, 64
   | 54, 50, 31,  0, 94
   | 45, 51, 64, 94,  0
  |];

% Variables
array[CITIES, CITIES] of var 0..1: x;  % x[i,j]=1 if travel directly i->j
array[CITIES] of var 1..n: u;          % MTZ order variables

var 0..sum(i in CITIES, j in CITIES where i != j)(cost[i,j]): total_cost;

% Constraints
constraint forall(i in CITIES)(x[i,i] = 0);

constraint forall(i in CITIES)(
  sum(j in CITIES)(x[i,j]) = 1
);
constraint forall(j in CITIES)(
  sum(i in CITIES)(x[i,j]) = 1
);

% MTZ subtour elimination (allows any start city)
constraint forall(i in CITIES)(u[i] >= 1 /\ u[i] <= n);
constraint forall(i in 2..n, j in 2..n where i != j)(
  u[i] - u[j] + n * x[i,j] <= n - 1
);

constraint total_cost = sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;