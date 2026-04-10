% Parameters
int: nCities = 4;                          % number of cities
set of int: CITIES = 1..nCities;           % city indices

array[CITIES, CITIES] of int: cost =       % travel cost matrix (0 on diagonal)
  [|  0, 27, 48, 76
   | 27,  0, 82, 88
   | 48, 82,  0, 97
   | 76, 88, 97,  0 |];

int: minCost = min([cost[i,j] | i in CITIES, j in CITIES where i != j]);  % for bounds
int: maxCost = max([cost[i,j] | i in CITIES, j in CITIES where i != j]);  % for bounds

% Variables
array[CITIES, CITIES] of var 0..1: x;      % x[i,j]=1 if travel directly from i to j
array[CITIES] of var 1..nCities: u;        % MTZ order variables for subtour elimination
var 0..(nCities * maxCost): totalCost;     % total tour cost (bounded)

% Constraints

% --- Basic arc validity: no self-loops ---
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

% --- MTZ subtour elimination constraints (prevent subtours) ---
% Fix one city's order to break symmetry
constraint
  u[1] = 1;

% Enforce ordering for cities 2..nCities
constraint
  forall(i in 2..nCities) (
    u[i] >= 2 /\ u[i] <= nCities
  );

% MTZ linking constraints for all i != j with i,j in {2..nCities}
constraint
  forall(i in 2..nCities, j in 2..nCities where i != j) (
    u[i] - u[j] + nCities * x[i,j] <= nCities - 1
  );

% --- Total cost definition ---
constraint
  totalCost = sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

% Objective
solve minimize totalCost;