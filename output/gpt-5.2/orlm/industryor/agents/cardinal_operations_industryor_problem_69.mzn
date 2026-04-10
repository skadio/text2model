% Parameters
int: nCities = 4;                         % Number of cities
set of int: CITIES = 1..nCities;          % City index set

array[CITIES, CITIES] of int: dist =      % Distance matrix between cities
  [| 0,  10, 20, 12
   | 10, 0,  5,  10
   | 20, 5,  0,  8
   | 15, 12, 8,  0 |];

int: startCity = 1;                       % Fixed starting/ending city


% Variables
array[CITIES, CITIES] of var 0..1: x;     % x[i,j]=1 if route goes directly from i to j
array[CITIES] of var 0..nCities: u;       % MTZ ordering variables for subtour elimination
var 0..sum(i in CITIES, j in CITIES)(dist[i,j]): totalDistance;  % Total traveled distance


% Constraints
%------------------------------------------------------------
% Compute total traveled distance from selected arcs
%------------------------------------------------------------
constraint
  totalDistance = sum(i in CITIES, j in CITIES)(dist[i,j] * x[i,j]);

%------------------------------------------------------------
% Disallow self-loops (cannot travel from a city to itself)
%------------------------------------------------------------
constraint
  forall(i in CITIES)(
    x[i,i] = 0
  );

%------------------------------------------------------------
% Exactly one outgoing arc from each city
%------------------------------------------------------------
constraint
  forall(i in CITIES)(
    sum(j in CITIES)(x[i,j]) = 1
  );

%------------------------------------------------------------
% Exactly one incoming arc to each city
%------------------------------------------------------------
constraint
  forall(j in CITIES)(
    sum(i in CITIES)(x[i,j]) = 1
  );

%------------------------------------------------------------
% Fix MTZ order variable for the start city
% (anchors the ordering to break symmetry and enable MTZ constraints)
%------------------------------------------------------------
constraint
  u[startCity] = 1;

%------------------------------------------------------------
% Bounds on MTZ order variables for non-start cities
%------------------------------------------------------------
constraint
  forall(i in CITIES where i != startCity)(
    u[i] >= 2 /\ u[i] <= nCities
  );

%------------------------------------------------------------
% MTZ subtour elimination constraints
% Prevent subtours by enforcing an ordering along selected arcs
% Applied only for i != j and excluding the start city as required by MTZ
%------------------------------------------------------------
constraint
  forall(i in CITIES, j in CITIES
         where i != j /\ i != startCity /\ j != startCity)(
    u[i] - u[j] + nCities * x[i,j] <= nCities - 1
  );


% Objective
solve minimize totalDistance;