% Parameters
int: nCities = 5;                               % number of cities
set of int: CITIES = 1..nCities;                % city indices (1=E, 2=F, 3=G, 4=H, 5=I)

array[CITIES, CITIES] of int: cost =            % travel cost matrix
  [|  0,  37,  72,  66,  33
   | 37,   0,  26,  56, 100
   | 72,  26,   0,  49,  32
   | 66,  56,  49,   0,  13
   | 33, 100,  32,  13,   0 |];

int: startCity = 1;                             % fix start city to E (1) to break symmetry


% Variables
array[CITIES] of var CITIES: succ;              % successor city in the tour for each city
array[CITIES] of var 1..nCities: pos;           % position of each city in the tour (MTZ-style)

var int: totalCost;                             % total tour cost (to be minimized)


% Constraints

% --- Tour structure: each city has exactly one successor and one predecessor ---
constraint
  all_different(succ); % ensures each city is the successor of exactly one city (unique predecessors)

% Disallow self-loops (no city can go to itself)
constraint
  forall(i in CITIES) (
    succ[i] != i
  );

% --- Symmetry breaking: fix start city position ---
constraint
  pos[startCity] = 1;

% --- MTZ subtour elimination + position domain restrictions ---
% Positions are a permutation of 1..nCities (each city appears exactly once in the order)
constraint
  all_different(pos);

% Ensure positions are within valid range (redundant due to var type, but explicit for clarity)
constraint
  forall(i in CITIES) (
    pos[i] >= 1 /\ pos[i] <= nCities
  );

% MTZ constraints: prevent subtours not including startCity
% For all i != startCity and j != startCity:
% pos[i] - pos[j] + nCities * (succ[i] == j) <= nCities - 1
constraint
  forall(i in CITIES where i != startCity) (
    forall(j in CITIES where j != startCity) (
      pos[i] - pos[j] + nCities * bool2int(succ[i] == j) <= nCities - 1
    )
  );

% --- Total cost calculation for the Hamiltonian cycle ---
constraint
  totalCost = sum(i in CITIES) ( cost[i, succ[i]] );


% Objective
solve minimize totalCost;