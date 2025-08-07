include "globals.mzn";

int: S;  % Total number of schools
int: G;  % Total number of student groups
int: N;  % Total number of neighborhoods

array[1..S, 1..G] of int: Capacity;  % Capacity of each school for each student group
array[1..N, 1..G] of int: Population; % Population of each student group in each neighborhood
array[1..N, 1..S] of float: Distance; % Distance between neighborhoods and schools

% Decision variables: number of students from neighborhood n assigned to school s for group g
array[1..N, 1..S, 1..G] of var 0..max(Population): assign;

% Objective: Minimize total distance traveled by all students
var float: total_distance = sum(n in 1..N, s in 1..S, g in 1..G)(assign[n, s, g] * Distance[n, s]);

% Constraints
% Each neighborhood's population must be fully assigned
constraint forall(n in 1..N, g in 1..G)(
    sum(s in 1..S)(assign[n, s, g]) = Population[n, g]
);

% School capacities must not be exceeded
constraint forall(s in 1..S, g in 1..G)(
    sum(n in 1..N)(assign[n, s, g]) <= Capacity[s, g]
);

% Solve & output
solve minimize total_distance;
output [ "Total Distance = ", show(total_distance), "\nAssignments = ", show(assign), "\n" ];