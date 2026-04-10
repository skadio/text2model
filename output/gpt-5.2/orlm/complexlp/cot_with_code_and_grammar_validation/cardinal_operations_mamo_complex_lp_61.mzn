% Parameters
int: n = 4;
set of int: Cities = 1..n; % 1=E, 2=F, 3=G, 4=H

array[Cities, Cities] of int: cost =
  [| 0, 17, 52, 79
   | 17, 0, 15, 71
   | 52, 15, 0, 54
   | 79, 71, 54, 0 |];

% Variables
array[Cities, Cities] of var 0..1: x;     % x[i,j]=1 if travel directly from i to j
array[Cities] of var 0..n: u;             % MTZ ordering variables
var 0..sum(i in Cities, j in Cities)(cost[i,j]): total_cost;

% Constraints
constraint forall(i in Cities)(x[i,i] = 0);

constraint forall(i in Cities)(
  sum(j in Cities)(x[i,j]) = 1
);

constraint forall(j in Cities)(
  sum(i in Cities)(x[i,j]) = 1
);

% MTZ subtour elimination
constraint u[1] = 1;
constraint forall(i in Cities where i != 1)(u[i] >= 2 /\ u[i] <= n);
constraint forall(i in Cities where i != 1, j in Cities where j != 1 /\ j != i)(
  u[i] - u[j] + n * x[i,j] <= n - 1
);

constraint total_cost = sum(i in Cities, j in Cities)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;