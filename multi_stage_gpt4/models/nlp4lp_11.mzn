% Parameters
int: S; % Total number of schools
int: G; % Total number of student groups
int: N; % Total number of neighborhoods
array[1..S, 1..G] of int: Capacity; % Capacity of school s for student group g
array[1..N, 1..G] of int: Population; % Population of student group g in neighborhood n
array[1..N, 1..S] of float: Distance; % Distance between neighborhood n and school s

% Variables
array[1..N, 1..S, 1..G] of var 0..max(Population): assignment; % Number of students from each neighborhood assigned to each school for each student group

% Constraints

% Each student group in each neighborhood must be assigned to a school
constraint forall(n in 1..N, g in 1..G) (
  sum(s in 1..S) (assignment[n, s, g]) = Population[n, g]
);

% The number of students assigned to a school for each student group must not exceed the capacity of the school for that group
constraint forall(s in 1..S, g in 1..G) (
  sum(n in 1..N) (assignment[n, s, g]) <= Capacity[s, g]
);

% The number of students assigned from a neighborhood to a school for each student group must be non-negative and not exceed the population of the student group in the neighborhood
constraint forall(n in 1..N, s in 1..S, g in 1..G) (
  0 <= assignment[n, s, g] /\ assignment[n, s, g] <= Population[n, g]
);

% Objective
solve minimize sum(n in 1..N, s in 1..S, g in 1..G) (assignment[n, s, g] * Distance[n, s]);