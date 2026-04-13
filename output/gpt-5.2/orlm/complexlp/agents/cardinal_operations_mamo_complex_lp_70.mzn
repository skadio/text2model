% Parameters
int: n = 4;                                 % Number of cities
set of int: CITIES = 1..n;                  % City indices

array[CITIES, CITIES] of int: cost =        % Travel cost matrix
  [|  0, 61, 17, 81
   | 61,  0, 40, 52
   | 17, 40,  0, 23
   | 81, 52, 23,  0 |];

% Variables
array[CITIES, CITIES] of var 0..1: x;       % x[i,j]=1 if travel directly from i to j
array[CITIES] of var 1..n: u;               % MTZ order variables for subtour elimination
var int: total_cost;                        % Total travel cost (to be minimized)

% Constraints

% --- Arc validity: no self-loops ---
constraint
  forall(i in CITIES) (
    x[i,i] = 0
  );

% --- Degree constraints: exactly one outgoing arc from each city ---
constraint
  forall(i in CITIES) (
    sum(j in CITIES)(x[i,j]) = 1
  );

% --- Degree constraints: exactly one incoming arc to each city ---
constraint
  forall(j in CITIES) (
    sum(i in CITIES)(x[i,j]) = 1
  );

% --- MTZ subtour elimination constraints (eliminate subtours) ---
% Fix one reference city order to break symmetry
constraint
  u[1] = 1;

% Order bounds for remaining cities (tighten domains)
constraint
  forall(i in 2..n) (
    u[i] >= 2 /\ u[i] <= n
  );

% MTZ linking constraints: if x[i,j]=1 then u[i] + 1 <= u[j] (for i!=j, i,j >= 2)
constraint
  forall(i in 2..n, j in 2..n where i != j) (
    u[i] - u[j] + n * x[i,j] <= n - 1
  );

% --- Total travel cost definition ---
constraint
  total_cost = sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;