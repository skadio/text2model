% Parameters (with values embedded)
int: N = 5;
set of int: CITIES = 1..N;

array[CITIES, CITIES] of int: cost =
  [|  0, 87, 41, 55, 57
   | 87,  0, 80, 33, 40
   | 41, 80,  0, 90, 42
   | 55, 33, 90,  0, 53
   | 57, 40, 42, 53,  0
  |];

% Variables
array[CITIES, CITIES] of var 0..1: x;          % x[i,j]=1 if travel directly i->j
array[CITIES] of var 1..N: u;                  % MTZ ordering variables
var 0..100000: total_cost;

% Constraints
constraint forall(i in CITIES) (x[i,i] = 0);

% Exactly one outgoing edge from each city
constraint forall(i in CITIES) (
  sum(j in CITIES)(x[i,j]) = 1
);

% Exactly one incoming edge to each city
constraint forall(j in CITIES) (
  sum(i in CITIES)(x[i,j]) = 1
);

% MTZ subtour elimination (allow any start city)
% Fix one city as reference to break symmetry (does not restrict the cycle)
constraint u[1] = 1;
constraint forall(i in 2..N)(u[i] >= 2 /\ u[i] <= N);

constraint forall(i in 2..N, j in 2..N where i != j) (
  u[i] - u[j] + N * x[i,j] <= N - 1
);

% Total cost
constraint total_cost = sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;