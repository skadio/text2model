% Parameters (with values embedded)
int: n = 6;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  [|  0, 21, 43, 25, 38, 91
   | 21,  0, 32, 25, 16, 14
   | 43, 32,  0, 96, 71, 98
   | 25, 25, 96,  0, 53, 22
   | 38, 16, 71, 53,  0,100
   | 91, 14, 98, 22,100,  0 |];

int: maxCost = 100;

% Variables
array[CITIES, CITIES] of var 0..1: x;   % x[i,j]=1 if travel from i to j
array[CITIES] of var 0..n-1: u;         % MTZ ordering variables
var 0..(n*maxCost): total_cost;

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

% MTZ subtour elimination (fix city 1 as reference)
constraint u[1] = 0;
constraint forall(i in 2..n)(u[i] >= 1 /\ u[i] <= n-1);

constraint forall(i in 2..n, j in 2..n where i != j)(
  u[i] - u[j] + n * x[i,j] <= n - 1
);

% Total cost
constraint total_cost = sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;