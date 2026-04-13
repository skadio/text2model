% School assignment (fractional flows) minimizing total distance

int: S;  % number of schools
int: G;  % number of student groups (grades)
int: N;  % number of neighborhoods

array[1..S, 1..G] of float: Capacity;     % capacity of school s for group g
array[1..N, 1..G] of float: Population;   % population in neighborhood n of group g
array[1..N, 1..S] of float: Distance;     % distance from neighborhood n to school s

% Decision variables:
% x[n,s,g] = number (possibly fractional) of students of group g from neighborhood n assigned to school s
array[1..N, 1..S, 1..G] of var float: x;

% Nonnegativity
constraint forall(n in 1..N, s in 1..S, g in 1..G) ( x[n,s,g] >= 0.0 );

% All students must be assigned (per neighborhood and group)
constraint forall(n in 1..N, g in 1..G) (
  sum(s in 1..S)( x[n,s,g] ) = Population[n,g]
);

% School capacities (per school and group)
constraint forall(s in 1..S, g in 1..G) (
  sum(n in 1..N)( x[n,s,g] ) <= Capacity[s,g]
);

% Objective: minimize total distance traveled by all students
var float: total_distance =
  sum(n in 1..N, s in 1..S, g in 1..G)( x[n,s,g] * Distance[n,s] );

solve minimize total_distance;

output [
  "TotalDistance = ", show(total_distance), "\n",
  "Assignment x[n,s,g] = ", show(x), "\n"
];