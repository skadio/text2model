% Traveling Salesman Problem (5 cities: E,F,G,H,I)
% Find minimum tour cost visiting each city exactly once and returning to start.

include "globals.mzn";

int: n = 5;
set of int: CITIES = 1..n;

array[CITIES] of string: name = ["E","F","G","H","I"];

% Cost matrix (0 on diagonal; symmetric as given)
array[CITIES, CITIES] of int: cost =
[
  %  E   F   G   H   I
  |  0, 50, 48, 99, 91  % E
  | 50,  0, 57, 84, 72  % F
  | 48, 57,  0, 46, 86  % G
  | 99, 84, 46,  0, 29  % H
  | 91, 72, 86, 29,  0  % I
];

% Fix a start city to remove rotational symmetry (any start gives same cycle cost)
int: start = 1; % City E

array[CITIES] of var CITIES: next;
constraint circuit(next);

% Enforce start=E by fixing successor of E to break symmetry further
% (also ensure E is in the cycle anyway)
constraint next[start] != start;

var int: total_cost =
  sum(i in CITIES)( cost[i, next[i]] );

solve minimize total_cost;

output [
  "Minimum total delivery cost = ", show(total_cost), "\n",
  "Tour (as next-city mapping):\n"
] ++
[
  name[i] ++ " -> " ++ name[fix(next[i])] ++ " (+" ++ show(cost[i, fix(next[i])]) ++ ")\n"
  | i in CITIES
];