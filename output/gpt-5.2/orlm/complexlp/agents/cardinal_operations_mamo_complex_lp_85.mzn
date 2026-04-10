% Parameters
int: n = 6;                                   % number of cities
set of int: CITIES = 1..n;                    % city indices

array[CITIES, CITIES] of int: cost =          % travel cost matrix (diagonal set to 0)
  [|  0, 63, 62, 49, 58, 38
   | 63,  0, 93, 21, 66, 42
   | 62, 93,  0, 26, 99, 96
   | 49, 21, 26,  0, 73, 80
   | 58, 66, 99, 73,  0, 76
   | 38, 42, 96, 80, 76,  0 |];

int: max_cost = max([cost[i,j] | i,j in CITIES]); % used for safe variable bounds


% Variables
array[CITIES, CITIES] of var 0..1: x;         % x[i,j]=1 if tour goes directly from i to j
array[CITIES] of var 1..n: u;                 % MTZ ordering variable to eliminate subtours
var 0..(n * max_cost): total_cost;            % total travel cost (upper bound is safe)


% Constraints

% --- No self-loops (do not travel from a city to itself) ---
constraint
  forall(i in CITIES) (
    x[i,i] = 0
  );

% --- Exactly one outgoing arc from each city ---
constraint
  forall(i in CITIES) (
    sum(j in CITIES)(x[i,j]) = 1
  );

% --- Exactly one incoming arc to each city ---
constraint
  forall(j in CITIES) (
    sum(i in CITIES)(x[i,j]) = 1
  );

% --- MTZ subtour elimination constraints (fix a reference city to break symmetry) ---
constraint
  u[1] = 1;

% Enforce ordering bounds for non-reference cities
constraint
  forall(i in 2..n) (
    u[i] >= 2 /\ u[i] <= n
  );

% MTZ linking constraints to eliminate subtours among cities 2..n
constraint
  forall(i in 2..n, j in 2..n where i != j) (
    u[i] - u[j] + n * x[i,j] <= n - 1
  );

% --- Total cost calculation ---
constraint
  total_cost =
    sum(i in CITIES, j in CITIES) (cost[i,j] * x[i,j]);


% Objective
solve minimize total_cost;