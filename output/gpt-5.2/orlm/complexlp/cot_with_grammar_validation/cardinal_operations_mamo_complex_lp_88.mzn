% Parameters
int: n = 5;
set of int: N = 1..n; % 1=E, 2=F, 3=G, 4=H, 5=I

array[N, N] of int: cost =
  [|   0,  65,  10,  25,  82
   |  65,   0,  98,  42,  26
   |  10,  98,   0,  75,  72
   |  25,  42,  75,   0,  46
   |  82,  26,  72,  46,   0 |];

% Variables
array[N, N] of var 0..1: x;               % x[i,j]=1 if travel i->j
array[N] of var 0..n-1: u;                % MTZ order variables (subtour elimination)
var 0..sum(i,j in N)(cost[i,j]): total_cost;

% Constraints
constraint forall(i in N)(x[i,i] = 0);

constraint forall(i in N)(
  sum(j in N)(x[i,j]) = 1
);

constraint forall(j in N)(
  sum(i in N)(x[i,j]) = 1
);

% Fix a representative start position to break symmetry
constraint u[1] = 0;
constraint forall(i in 2..n)(u[i] >= 1 /\ u[i] <= n-1);

% MTZ subtour elimination
constraint forall(i in 2..n, j in 2..n where i != j)(
  u[i] - u[j] + n * x[i,j] <= n - 1
);

constraint total_cost = sum(i,j in N)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;