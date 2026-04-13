include "globals.mzn";

% Parameters
int: nCities = 5;                         % number of cities
set of int: CITIES = 1..nCities;          % city indices (1=E, 2=F, 3=G, 4=H, 5=I)

array[CITIES, CITIES] of int: cost =
  [|   0, 50, 48, 99, 91
   |  50,  0, 57, 84, 72
   |  48, 57,  0, 46, 86
   |  99, 84, 46,  0, 29
   |  91, 72, 86, 29,  0 |];

int: maxCost = max([cost[i,j] | i,j in CITIES]);

% Variables
array[CITIES] of var CITIES: succ;        % succ[i] = next city visited after city i
array[CITIES] of var CITIES: pred;        % pred[i] = previous city visited before city i
var 0..(nCities * maxCost): totalCost;

% Constraints

% 1) Successor and predecessor must be inverse mappings
constraint
  forall(i in CITIES) (
    pred[succ[i]] = i /\
    succ[pred[i]] = i
  );

% 2) Each city has exactly one outgoing and one incoming arc
constraint all_different(succ);
constraint all_different(pred);

% 3) No self-loops
constraint forall(i in CITIES) (succ[i] != i /\ pred[i] != i);

% 4) Single Hamiltonian cycle
constraint circuit(succ);

% 5) Total cost
constraint totalCost = sum(i in CITIES) (cost[i, succ[i]]);

solve minimize totalCost;

output [
  "totalCost = ", show(totalCost), "\n",
  "succ = ", show(succ), "\n"
];