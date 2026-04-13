% Parameters
int: n = 6;                                  % Number of cities
set of int: CITIES = 1..n;                   % City indices

array[CITIES, CITIES] of int: cost =         % Travel cost matrix (including 0 on diagonal)
  [|  0, 21, 43, 25, 38, 91
   | 21,  0, 32, 25, 16, 14
   | 43, 32,  0, 96, 71, 98
   | 25, 25, 96,  0, 53, 22
   | 38, 16, 71, 53,  0,100
   | 91, 14, 98, 22,100,  0 |];

% Variables
array[CITIES, CITIES] of var 0..1: x;        % x[i,j] = 1 if the tour goes directly from i to j
array[CITIES] of var 1..n: u;                % MTZ ordering variables (subtour elimination aid)
var 0..100000: total_cost;                   % Total travel cost (safe upper bound)

% Constraints
% No self-loops
constraint forall(i in CITIES)(x[i,i] = 0);

% Link total_cost to selected arcs (sum of travel costs on chosen edges)
constraint
  total_cost =
    sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

% Exactly one outgoing arc from each city
constraint
  forall(i in CITIES)(
    sum(j in CITIES)(x[i,j]) = 1
  );

% Exactly one incoming arc to each city
constraint
  forall(j in CITIES)(
    sum(i in CITIES)(x[i,j]) = 1
  );

% Fix a reference city for MTZ ordering to break symmetry (start city can be any)
constraint u[1] = 1;

% MTZ subtour elimination constraints:
% Prevent cycles that do not include the reference city (city 1).
constraint
  forall(i, j in CITIES where i != j /\ i != 1 /\ j != 1)(
    u[i] - u[j] + n * x[i,j] <= n - 1
  );

% Objective
solve minimize total_cost;