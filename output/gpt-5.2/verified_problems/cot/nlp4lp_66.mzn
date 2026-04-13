% Parameters
int: N;
int: StartCity;
array[1..N, 1..N] of int: Distances;

set of int: Cities = 1..N;

% Variables
array[Cities] of var Cities: succ;
array[Cities] of var Cities: pred;
var int: total_distance;

% Constraints
constraint forall(i in Cities) (succ[i] != i);
constraint forall(i in Cities) (pred[i] != i);

constraint inverse(succ, pred);
constraint circuit(succ);

constraint StartCity >= 1 /\ StartCity <= N;

constraint total_distance = sum(i in Cities)(Distances[i, succ[i]]);

% Objective
solve minimize total_distance;