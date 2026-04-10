include "globals.mzn";

% Parameters
int: nCities = 6;
set of int: CITIES = 1..nCities;

array[CITIES, CITIES] of int: cost =
  [|  0, 86, 81, 64, 65, 24
   | 86,  0, 44, 80, 91, 23
   | 81, 44,  0, 15, 25, 89
   | 64, 80, 15,  0, 89, 41
   | 65, 91, 25, 89,  0, 29
   | 24, 23, 89, 41, 29,  0 |];

int: maxCost = max([cost[i,j] | i in CITIES, j in CITIES]);

% Variables
array[CITIES] of var CITIES: succ;        % succ[i] = next city visited after i
array[CITIES] of var 0..nCities-1: u;     % MTZ order variables
var 0..nCities*maxCost: totalCost;

% Constraints

% Each city has exactly one outgoing and one incoming arc (permutation)
constraint all_different(succ);

% No self-loops
constraint forall(i in CITIES) (succ[i] != i);

% MTZ subtour elimination
constraint u[1] = 0;
constraint forall(i in CITIES where i != 1) (u[i] >= 1 /\ u[i] <= nCities - 1);

constraint
  forall(i in CITIES where i != 1) (
    forall(j in CITIES where j != 1 /\ j != i) (
      (succ[i] = j) -> (u[i] - u[j] + nCities <= nCities - 1)
    )
  );

% Total cost
constraint totalCost = sum(i in CITIES) (cost[i, succ[i]]);

% Objective
solve minimize totalCost;

output [
  "totalCost = ", show(totalCost), "\n",
  "succ = ", show(succ), "\n"
];