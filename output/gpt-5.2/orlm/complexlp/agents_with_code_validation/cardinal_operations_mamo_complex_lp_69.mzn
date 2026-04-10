% Parameters
int: n = 6;                                  % number of cities
set of int: CITIES = 1..n;                   % city indices

array[CITIES, CITIES] of int: cost =         % travel cost matrix
[|  0, 83, 30, 38, 51, 64
 | 47,  0, 93, 13, 72, 58
 | 29, 33,  0, 85, 17, 41
 | 65, 19, 54,  0, 36, 28
 | 87, 42, 66, 39,  0, 74
 | 52, 61, 24, 57, 46,  0 |];

% Variables
array[CITIES, CITIES] of var 0..1: x;        % x[i,j] = 1 if tour goes directly i -> j
array[CITIES] of var 1..n: u;                % MTZ ordering variables (for subtour elimination)
var 0..(n * max([cost[i,j] | i,j in CITIES])): total_cost;  % total travel cost (bounded)

% Constraints

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

% --- No self-loops (cannot travel from a city to itself) ---
constraint
  forall(i in CITIES) (
    x[i,i] = 0
  );

% --- MTZ subtour elimination constraints ---
% Fix a reference city ordering to break symmetry and anchor the tour.
constraint u[1] = 1;

% Enforce order bounds for the remaining cities (keeps MTZ tight and consistent).
constraint
  forall(i in 2..n) (
    u[i] >= 2 /\ u[i] <= n
  );

% MTZ constraints to eliminate subtours:
% if arc i->j is used then u[j] >= u[i] + 1 (for i,j != 1), linearized with big-M (M = n).
constraint
  forall(i in 2..n, j in 2..n where i != j) (
    u[i] - u[j] + n * x[i,j] <= n - 1
  );

% --- Total travel cost accumulation ---
constraint
  total_cost = sum(i in CITIES, j in CITIES) (cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;