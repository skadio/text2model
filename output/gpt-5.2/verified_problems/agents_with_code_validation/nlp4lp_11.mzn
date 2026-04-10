% Parameters
int: S;                                   % total number of schools
int: G;                                   % total number of student groups (grades)
int: N;                                   % total number of neighborhoods

array[1..S, 1..G] of float: Capacity;     % capacity of school s for group g
array[1..N, 1..G] of float: Population;   % population in neighborhood n for group g
array[1..N, 1..S] of float: Distance;     % distance from neighborhood n to school s

% Decision variables (continuous, nonnegative)
array[1..N, 1..S, 1..G] of var float: Assign;

% Constraints
constraint
  forall(n in 1..N, g in 1..G) (
    sum(s in 1..S)(Assign[n, s, g]) = Population[n, g]
  );

constraint
  forall(s in 1..S, g in 1..G) (
    sum(n in 1..N)(Assign[n, s, g]) <= Capacity[s, g]
  );

constraint
  forall(n in 1..N, s in 1..S, g in 1..G) (
    Assign[n, s, g] >= 0.0
  );

% Objective: minimize total distance traveled
% (use objective expression directly to avoid Float::linear limits in Gecode)
solve minimize
  sum(n in 1..N, s in 1..S, g in 1..G)(
    Assign[n, s, g] * Distance[n, s]
  );