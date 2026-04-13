% Parameters (with values embedded)
int: n = 5;
set of int: CITIES = 1..n;
% City index mapping: 1=E, 2=F, 3=G, 4=H, 5=I
array[CITIES, CITIES] of int: cost =
  [|  0, 31, 19, 71, 74
   | 31,  0, 39, 77, 84
   | 19, 39,  0, 65, 78
   | 71, 77, 65,  0, 38
   | 74, 84, 78, 38,  0 |];

% Variables
array[CITIES] of var CITIES: succ;   % successor city in the tour
array[CITIES] of var CITIES: pred;   % predecessor city in the tour
var 0..10000: total_cost;

% Constraints
constraint
  forall(i in CITIES) (
    succ[i] != i /\ pred[i] != i
  );

constraint
  inverse(succ, pred);

constraint
  circuit(succ);

constraint
  total_cost = sum(i in CITIES)( cost[i, succ[i]] );

% Objective
solve minimize total_cost;