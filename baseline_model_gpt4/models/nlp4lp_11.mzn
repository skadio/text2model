include "globals.mzn";

% Parameters
int: S; % Total number of schools
int: G; % Total number of student groups
int: N; % Total number of neighborhoods
array[1..S, 1..G] of int: Capacity; % Capacity of school s for student group g
array[1..N, 1..G] of int: Population; % Population of student group g in neighborhood n
array[1..N, 1..S] of float: Distance; % Distance between neighborhood n and school s

% Decision variables
array[1..N, 1..S, 1..G] of var 0..max(Population): Assign; % Number of students from neighborhood n, group g assigned to school s

% Objective: Minimize total distance traveled by all students
var float: total_distance = sum(n in 1..N, s in 1..S, g in 1..G) (Assign[n,s,g] * Distance[n,s]);
minimize total_distance;

% Constraints
% Each student is assigned to a school
constraint forall(n in 1..N, g in 1..G) (sum(s in 1..S) (Assign[n,s,g]) = Population[n,g]);

% The number of students assigned to a school does not exceed its capacity
constraint forall(s in 1..S, g in 1..G) (sum(n in 1..N) (Assign[n,s,g]) <= Capacity[s,g]);

solve satisfy;