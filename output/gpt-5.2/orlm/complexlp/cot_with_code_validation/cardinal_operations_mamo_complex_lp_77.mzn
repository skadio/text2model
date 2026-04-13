% Parameters
int: n = 4;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  [| 0, 27, 48, 76
   | 27, 0, 82, 88
   | 48, 82, 0, 97
   | 76, 88, 97, 0 |];

% Variables
array[CITIES, CITIES] of var 0..1: x;
var 0..sum(i,j in CITIES where i != j)(cost[i,j]): total_cost;

% Constraints
constraint forall(i in CITIES)(x[i,i] = 0);

constraint forall(i in CITIES)(
  sum(j in CITIES)(x[i,j]) = 1
);

constraint forall(j in CITIES)(
  sum(i in CITIES)(x[i,j]) = 1
);

constraint total_cost = sum(i,j in CITIES)(cost[i,j] * x[i,j]);

% Subtour elimination (MTZ)
array[CITIES] of var 0..n-1: u;
constraint u[1] = 0;
constraint forall(i in CITIES where i != 1)(u[i] >= 1);
constraint forall(i in CITIES, j in CITIES where i != j /\ i != 1 /\ j != 1)(
  u[i] - u[j] + n * x[i,j] <= n - 1
);

% Objective
solve minimize total_cost;