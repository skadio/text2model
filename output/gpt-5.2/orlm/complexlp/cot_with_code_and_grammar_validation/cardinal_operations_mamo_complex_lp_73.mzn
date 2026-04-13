% Parameters
int: N = 5;
set of int: Cities = 1..N;

% City indices: 1=E, 2=F, 3=G, 4=H, 5=I
array[Cities, Cities] of int: cost =
  [| 0,  37, 72, 66, 33
   | 37, 0,  26, 56, 100
   | 72, 26, 0,  49, 32
   | 66, 56, 49, 0,  13
   | 33, 100,32, 13, 0  |];

% Variables
array[Cities, Cities] of var 0..1: x; % x[i,j]=1 if travel from i to j
var 0..1000000: total_cost;

% Constraints
constraint forall(i in Cities) (x[i,i] = 0);

constraint forall(i in Cities) (
  sum(j in Cities)(x[i,j]) = 1
);

constraint forall(j in Cities) (
  sum(i in Cities)(x[i,j]) = 1
);

% Subtour elimination (MTZ)
array[Cities] of var 0..N-1: u;
constraint u[1] = 0;
constraint forall(i in 2..N) (u[i] >= 1 /\ u[i] <= N-1);

constraint forall(i in 2..N, j in 2..N where i != j) (
  u[i] - u[j] + N * x[i,j] <= N - 1
);

% Total cost definition
constraint total_cost = sum(i in Cities, j in Cities)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;