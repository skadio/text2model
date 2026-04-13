include "globals.mzn";

% Parameters
int: n = 6;
set of int: Cities = 1..n;

array[Cities, Cities] of int: cost =
  [|  0, 21, 43, 25, 38, 91
   | 21,  0, 32, 25, 16, 14
   | 43, 32,  0, 96, 71, 98
   | 25, 25, 96,  0, 53, 22
   | 38, 16, 71, 53,  0,100
   | 91, 14, 98, 22,100,  0 |];

% Variables
array[Cities, Cities] of var 0..1: x;     % x[i,j] = 1 if travel directly from i to j
array[Cities] of var Cities: succ;        % successor city for each city
var int: total_cost;

% Link arc-decision variables x to successor representation succ
constraint
  forall(i in Cities, j in Cities) (
    x[i,j] = bool2int(succ[i] = j)
  );

% Disallow self-loops
constraint forall(i in Cities) ( succ[i] != i );

% Exactly one outgoing arc from each city (redundant but fine)
constraint forall(i in Cities) ( sum(j in Cities)(x[i,j]) = 1 );

% Exactly one incoming arc to each city (redundant but fine)
constraint forall(j in Cities) ( sum(i in Cities)(x[i,j]) = 1 );

% Ensure a single Hamiltonian cycle
constraint circuit(succ);

% Total cost
constraint total_cost = sum(i in Cities, j in Cities)(cost[i,j] * x[i,j]);

solve minimize total_cost;