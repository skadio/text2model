% Parameters (with values embedded)
int: n = 6;
set of int: Cities = 1..n;

array[Cities, Cities] of int: cost =
[
|  0, 83, 30, 38, 90, 76
| 72,  0, 93, 13, 55, 41
| 64, 18,  0, 85, 17, 29
| 44, 62, 27,  0, 71, 39
| 87, 42, 60, 33,  0, 58
| 25, 81, 49, 66, 22,  0
];

% Variables
array[Cities, Cities] of var 0..1: x;        % x[i,j]=1 if travel i->j
array[Cities] of var 1..n: u;                 % MTZ ordering variables

% Constraints
constraint forall(i in Cities) (x[i,i] = 0);

% Exactly one outgoing arc from each city
constraint forall(i in Cities) (
  sum(j in Cities)(x[i,j]) = 1
);

% Exactly one incoming arc to each city
constraint forall(j in Cities) (
  sum(i in Cities)(x[i,j]) = 1
);

% MTZ subtour elimination
constraint u[1] = 1;
constraint forall(i in 2..n) (u[i] >= 2 /\ u[i] <= n);

constraint forall(i in 2..n, j in 2..n where i != j) (
  u[i] - u[j] + n * x[i,j] <= n - 1
);

% Objective
var int: total_cost = sum(i in Cities, j in Cities)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output ["minimum_total_travel_cost = ", show(total_cost), "\n"];