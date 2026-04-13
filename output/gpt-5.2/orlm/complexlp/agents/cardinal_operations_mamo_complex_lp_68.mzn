% Parameters
include "globals.mzn";

int: nCities = 5;                           % Number of cities
set of int: CITIES = 1..nCities;            % City index set

array[CITIES, CITIES] of int: cost =        % Travel cost matrix (diagonal set to 0)
  [|  0, 40, 40, 56, 93
   | 40,  0, 52, 71, 90
   | 40, 52,  0, 57, 14
   | 56, 71, 57,  0, 13
   | 93, 90, 14, 13,  0 |];

int: maxCost = max([ cost[i,j] | i in CITIES, j in CITIES ]);  % Upper bound for single leg
int: maxTourCost = nCities * maxCost;                           % Safe upper bound for tour cost


% Variables
array[CITIES] of var CITIES: nextCity;        % nextCity[i] = city visited immediately after i
array[CITIES] of var CITIES: prevCity;        % prevCity[j] = city visited immediately before j

array[CITIES] of var 1..nCities: visitOrder;  % MTZ order to prevent subtours (1..nCities)
var 0..maxTourCost: totalCost;                % Total tour cost (bounded)


% Constraints
% (Optional explicit constraints for variable bounds/validity)
constraint forall(i in CITIES)(nextCity[i] != i);  % No self-loop
constraint forall(i in CITIES)(prevCity[i] != i);  % No self-loop

% --- Degree / permutation constraints (each city has exactly one successor and one predecessor) ---
constraint all_different(nextCity);   % no two cities go to the same next city
constraint all_different(prevCity);   % no two cities come from the same previous city

% --- Link nextCity and prevCity consistently (inverse relationship) ---
constraint forall(i in CITIES)( prevCity[nextCity[i]] = i );
constraint forall(j in CITIES)( nextCity[prevCity[j]] = j );

% --- MTZ subtour elimination using visitOrder (ensures a single Hamiltonian cycle) ---
% Fix an anchor to break symmetry in the MTZ order (does not fix the start city of the tour itself)
constraint visitOrder[1] = 1;

% Enforce ordering along arcs, excluding arcs entering the anchor city 1
constraint
  forall(i in CITIES where i != 1)(
    forall(j in CITIES where j != 1)(
      (nextCity[i] = j) -> (visitOrder[j] = visitOrder[i] + 1)
    )
  );

% City 1 must be last (order nCities) iff it is the successor of some non-1 city
constraint
  forall(i in CITIES where i != 1)(
    (nextCity[i] = 1) -> (visitOrder[i] = nCities)
  );

% --- Total cost accumulation ---
constraint
  totalCost = sum(i in CITIES)(cost[i, nextCity[i]]);


% Objective
solve minimize totalCost;