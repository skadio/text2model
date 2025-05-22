int: S;                      % number of schools
int: G;                      % number of student groups
int: N;                      % number of neighbourhoods

array[1..S, 1..G] of int: Capacity;      % capacity of school s for group g
array[1..N, 1..G] of int: Population;    % population of group g in neighbourhood n
array[1..N, 1..S] of float: Distance;    % distance from neighbourhood n to school s

% Auxiliary constants
int: max_pop = max([Population[n,g] | n in 1..N, g in 1..G]);
float: max_pop_f = float(max_pop);       % upper bound for assignment variables

% Variables
array[1..N, 1..S, 1..G] of var 0.0..max_pop_f: x;   % students of group g from n sent to s

% Every student is assigned
constraint
  forall(n in 1..N, g in 1..G) (
    sum(s in 1..S)(x[n,s,g]) = float(Population[n,g])
  );

% School capacities are respected
constraint
  forall(s in 1..S, g in 1..G) (
    sum(n in 1..N)(x[n,s,g]) <= float(Capacity[s,g])
  );

% Objective
solve minimize
  sum(n in 1..N, s in 1..S, g in 1..G)(Distance[n,s] * x[n,s,g]);