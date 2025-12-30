% Parameters
int: S; % Total number of schools
int: G; % Total number of student groups
int: N; % Total number of neighborhoods
array[1..S, 1..G] of int: Capacity; % Capacity of school s for student group g
array[1..N, 1..G] of int: Population; % Population of student group g in neighborhood n
array[1..N, 1..S] of float: Distance; % Distance between neighborhood n and school s

% Variables
% Assignment of students from each neighborhood and group to each school
% The value at index [n, g, s] represents the number of students from neighborhood n and group g assigned to school s
array[1..N, 1..G, 1..S] of var 0..max(Population): assignment;

% Constraints

% Constraint 1: The total number of students assigned from each neighborhood and group should be equal to the population of that group in the neighborhood
constraint forall(n in 1..N, g in 1..G)(
  sum(s in 1..S)(assignment[n, g, s]) = Population[n, g]
);

% Constraint 2: The total number of students assigned to each school and group should not exceed the capacity of that group at the school
constraint forall(s in 1..S, g in 1..G)(
  sum(n in 1..N)(assignment[n, g, s]) <= Capacity[s, g]
);

% Constraint 3: The number of students assigned from each neighborhood to each school should be non-negative
constraint forall(n in 1..N, g in 1..G, s in 1..S)(
  assignment[n, g, s] >= 0
);

% Objective
% Minimize the total distance traveled by all students
solve minimize sum(n in 1..N, g in 1..G, s in 1..S)(assignment[n, g, s] * Distance[n, s]);