% Parameters
int: nCities = 4;                                % Number of cities
set of int: CITIES = 1..nCities;                 % City indices: 1=A, 2=B, 3=C, 4=D

array[CITIES, CITIES] of int: cost =             % Travel cost matrix
  [|  0, 61, 65, 63
   | 61,  0, 94, 31
   | 65, 94,  0, 19
   | 63, 31, 19,  0 |];

% Variables
array[CITIES] of var CITIES: succ;               % succ[i] = next city visited after i
array[CITIES] of var 1..nCities: ord;            % Order/position of each city in the tour (for subtour elimination)
var int: totalCost;                              % Total travel cost of the tour

% Constraints

% --- Tour structure: each city has exactly one successor and one predecessor ---
constraint
  all_different(succ);  % permutation of successors => one outgoing arc per city and unique predecessors

% --- Subtour elimination and ordering (MTZ-style) ---
constraint
  all_different(ord);   % each city gets a unique position in the tour

% Fix a reference city to break symmetry (choose city 1 as position 1)
constraint
  ord[1] = 1;

% Link ordering with successors to prevent subtours:
% If succ[i] = j and i is not the last in order, then ord[j] = ord[i] + 1
constraint
  forall(i in CITIES) (
    (ord[i] < nCities) -> (ord[succ[i]] = ord[i] + 1)
  );

% Ensure the last city in the order goes back to the first city (city 1)
constraint
  forall(i in CITIES) (
    (ord[i] = nCities) -> (succ[i] = 1)
  );

% --- Total cost computation ---
constraint
  totalCost = sum(i in CITIES)( cost[i, succ[i]] );

% Objective
solve minimize totalCost;