int: S;                       % Number of schools
int: G;                       % Number of student groups
int: N;                       % Number of neighborhoods

array[1..S, 1..G] of int: Capacity;     % capacity of school s for group g
array[1..N, 1..G] of int: Population;   % population of group g in neighborhood n
array[1..N, 1..S] of float: Distance;   % distance from neighborhood n to school s

% Upper bound for decision variables (largest neighborhood–group population)
int: MaxPopulation = max([Population[n, g] | n in 1..N, g in 1..G]);

% Decision variables: number of students of (n,g) assigned to school s
array[1..N, 1..G, 1..S] of var 0..MaxPopulation: x;

% Every student in each neighborhood–group is assigned to some school
constraint
  forall(n in 1..N, g in 1..G) (
    sum(s in 1..S) (x[n, g, s]) = Population[n, g]
  );

% School capacity for each group is not exceeded
constraint
  forall(s in 1..S, g in 1..G) (
    sum(n in 1..N) (x[n, g, s]) <= Capacity[s, g]
  );

% Objective: minimise total travel distance
var float: total_distance =
  sum(n in 1..N, g in 1..G, s in 1..S) (
    Distance[n, s] * int2float(x[n, g, s])
  );

solve minimize total_distance;