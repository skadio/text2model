include "globals.mzn";

% Parameters
int: n = 4;
set of int: N = 1..n; % 1=A, 2=B, 3=C, 4=D

array[N, N] of int: cost =
  [| 0, 61, 65, 63
   | 61, 0, 94, 31
   | 65, 94, 0, 19
   | 63, 31, 19, 0 |];

% Variables
array[N] of var N: succ;          % successor city in tour
array[N] of var N: pred;          % predecessor city in tour
var 0..1000000: total_cost;

% Constraints
constraint circuit(succ);

constraint forall(i in N) (
  pred[succ[i]] = i
);

constraint total_cost = sum(i in N)( cost[i, succ[i]] );

% Objective
solve minimize total_cost;