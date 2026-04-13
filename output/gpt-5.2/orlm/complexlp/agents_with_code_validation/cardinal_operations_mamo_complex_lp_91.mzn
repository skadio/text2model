include "globals.mzn";

% Parameters
int: n = 5;                         % Number of cities
set of int: Cities = 1..n;          % City indices (1=A, 2=B, 3=C, 4=D, 5=E)

% Travel cost matrix (cost[i,j] = cost to go from city i to city j)
array[Cities, Cities] of int: cost =
  [|  0, 95, 36, 93, 16
   | 95,  0, 95, 29, 96
   | 36, 95,  0, 72, 38
   | 93, 29, 72,  0, 77
   | 16, 96, 38, 77,  0 |];

% Variables
array[Cities, Cities] of var 0..1: x;     % x[i,j]=1 if the tour goes directly from i to j
array[Cities] of var Cities: succ;        % successor city for each city in the tour
var 0..sum(i in Cities, j in Cities)(cost[i,j]): total_cost;

% Constraints
constraint forall(i in Cities) (x[i,i] = 0);

% Exactly one outgoing and one incoming arc for each city
constraint forall(i in Cities) (sum(j in Cities)(x[i,j]) = 1);
constraint forall(i in Cities) (sum(j in Cities)(x[j,i]) = 1);

% Link x to succ: succ[i] is the unique j with x[i,j]=1
constraint forall(i in Cities) (
  succ[i] = sum(j in Cities)(j * x[i,j])
);

% Single Hamiltonian cycle (no subtours)
constraint circuit(succ);

% Total travel cost
constraint total_cost = sum(i in Cities, j in Cities)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];