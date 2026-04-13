% Parameters
int: n = 4;
set of int: CITIES = 1..n;

% City index mapping:
% 1 = Alpha, 2 = Bravo, 3 = Charlie, 4 = Delta
array[CITIES, CITIES] of int: cost =
  [| 0, 41, 55, 22
   | 41, 0, 47, 47
   | 55, 47, 0, 35
   | 22, 47, 35, 0 |];

% Variables
array[CITIES, CITIES] of var 0..1: x;        % x[i,j] = 1 if travel i -> j
array[CITIES] of var 1..n: u;                % MTZ ordering variables
var 0..100000: total_cost;

% Constraints
constraint forall(i in CITIES)(x[i,i] = 0);

% Exactly one outgoing arc from each city
constraint forall(i in CITIES)(
  sum(j in CITIES)(x[i,j]) = 1
);

% Exactly one incoming arc to each city
constraint forall(j in CITIES)(
  sum(i in CITIES)(x[i,j]) = 1
);

% Subtour elimination (MTZ)
constraint u[1] = 1;
constraint forall(i in 2..n)(u[i] >= 2 /\ u[i] <= n);
constraint forall(i in 2..n, j in 2..n where i != j)(
  u[i] - u[j] + n * x[i,j] <= n - 1
);

% Total cost
constraint total_cost = sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;