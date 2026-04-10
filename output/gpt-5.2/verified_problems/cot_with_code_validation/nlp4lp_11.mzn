% Parameters
int: S;
int: G;
int: N;

array[1..S, 1..G] of float: Capacity;
array[1..N, 1..G] of float: Population;
array[1..N, 1..S] of float: Distance;

% Variables: number of students from neighborhood n in group g assigned to school s
array[1..N, 1..S, 1..G] of var float: Assign;

% Constraints: all students in each neighborhood/group must be assigned
constraint
  forall(n in 1..N, g in 1..G) (
    sum(s in 1..S)(Assign[n,s,g]) = Population[n,g]
  );

% School capacity constraints per group
constraint
  forall(s in 1..S, g in 1..G) (
    sum(n in 1..N)(Assign[n,s,g]) <= Capacity[s,g]
  );

% Nonnegativity
constraint
  forall(n in 1..N, s in 1..S, g in 1..G) (
    Assign[n,s,g] >= 0.0
  );

% Objective: minimize total distance traveled
solve minimize
  sum(n in 1..N, s in 1..S, g in 1..G) (
    Distance[n,s] * Assign[n,s,g]
  );