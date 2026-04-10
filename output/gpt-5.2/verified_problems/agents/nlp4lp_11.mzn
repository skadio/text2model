% Parameters
int: S; % total number of schools
int: G; % total number of student groups (grades)
int: N; % total number of neighborhoods

set of int: SCHOOLS = 1..S;
set of int: GROUPS  = 1..G;
set of int: NEIGHS  = 1..N;

array[SCHOOLS, GROUPS] of float: Capacity;     % capacity of school s for group g
array[NEIGHS,  GROUPS] of float: Population;   % population of group g in neighborhood n
array[NEIGHS,  SCHOOLS] of float: Distance;    % distance between neighborhood n and school s

% Variables
array[NEIGHS, SCHOOLS, GROUPS] of var float: Assign; % amount of group g from n assigned to s (fractional allowed)
var float: total_distance; % total distance traveled by all assigned students

% Constraints

% All students in each (neighborhood, group) must be assigned to some school
constraint
  forall(n in NEIGHS, g in GROUPS) (
    sum(s in SCHOOLS)(Assign[n,s,g]) = Population[n,g]
  );

% Assigned amounts cannot be negative
constraint
  forall(n in NEIGHS, s in SCHOOLS, g in GROUPS) (
    Assign[n,s,g] >= 0.0
  );

% School capacity per group cannot be exceeded
constraint
  forall(s in SCHOOLS, g in GROUPS) (
    sum(n in NEIGHS)(Assign[n,s,g]) <= Capacity[s,g]
  );

% Total distance traveled by all students
constraint
  total_distance =
    sum(n in NEIGHS, s in SCHOOLS, g in GROUPS) (
      Assign[n,s,g] * Distance[n,s]
    );

% Objective
solve minimize total_distance;