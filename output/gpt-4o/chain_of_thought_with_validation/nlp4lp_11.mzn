% Parameters
int: S;
int: G;
int: N;

array[1..S, 1..G] of float: Capacity;
array[1..N, 1..G] of float: Population;
array[1..N, 1..S] of float: Distance;

float: BIG_M = max([Population[n,g] | n in 1..N, g in 1..G]);

% Variables
array[1..N, 1..G, 1..S] of var 0.0..BIG_M: Assign;

% Constraints
constraint
  forall(n in 1..N, g in 1..G)(
    sum(s in 1..S)(Assign[n,g,s]) = Population[n,g]
  );

constraint
  forall(s in 1..S, g in 1..G)(
    sum(n in 1..N)(Assign[n,g,s]) <= Capacity[s,g]
  );

% Objective
var float: total_distance =
  sum(n in 1..N, g in 1..G, s in 1..S)(Assign[n,g,s] * Distance[n,s]);

solve minimize total_distance;