include "globals.mzn";

% Parameters
int: S; % Total number of schools
int: G; % Total number of student groups
int: N; % Total number of neighborhoods
array[1..S, 1..G] of int: Capacity; % Capacity of school s for student group g
array[1..N, 1..G] of int: Population; % Population of student group g in neighborhood n
array[1..N, 1..S] of float: Distance; % Distance between neighborhood n and school s

% Variables
array[1..N, 1..S, 1..G] of var 0..max(Population): assignment;

% Constraints
constraint forall(n in 1..N, g in 1..G) (
    sum(s in 1..S) (assignment[n, s, g]) = Population[n, g]
);

constraint forall(s in 1..S, g in 1..G) (
    sum(n in 1..N) (assignment[n, s, g]) <= Capacity[s, g]
);

% Objective
var float: total_distance = sum(n in 1..N, s in 1..S, g in 1..G) (assignment[n, s, g] * Distance[n, s]);

solve minimize total_distance;

% Output
output [ "Total distance: ", show(total_distance), "\n" ] ++
[ if fix(assignment[n, s, g]) > 0 then "Neighborhood " ++ show(n) ++ " sends " ++ show(assignment[n, s, g]) ++ " students from group " ++ show(g) ++ " to school " ++ show(s) ++ ".\n" else "" endif | n in 1..N, s in 1..S, g in 1..G ];