include "globals.mzn";

% Input parameters provided via data file
int: S;  % number of schools
int: G;  % number of student groups (grades)
int: N;  % number of neighborhoods

array[1..S, 1..G] of float: Capacity;
array[1..N, 1..G] of float: Population;
array[1..N, 1..S] of float: Distance;

% To declare useful bounds for the decision variables, we note that no school can receive more 
% students from a neighborhood-group than that neighborhood has in that group.
% So we compute an upper bound, common to every assignment variable.
float: maxPop = max(n in 1..N, g in 1..G)(Population[n, g]);

% Decision variables:
% x[n,s,g] is the (possibly fractional) number of students from neighborhood n,
% belonging to student group g, assigned to school s.
array[1..N, 1..S, 1..G] of var 0.0..maxPop: x;

% Constraint 1: All students in each neighborhood and group must be assigned
constraint
  forall(n in 1..N, g in 1..G) (
    sum(s in 1..S)( x[n,s,g] ) = Population[n, g]
  );

% Constraint 2: No school exceeds its capacity for any student group
constraint
  forall(s in 1..S, g in 1..G) (
    sum(n in 1..N)( x[n,s,g] ) <= Capacity[s, g]
  );

% Objective: Minimize total distance traveled by all students.
% The distance for each (n,s) pair is given in Distance, and applies to every group.
solve minimize 
  sum(n in 1..N, s in 1..S, g in 1..G)( Distance[n,s] * x[n,s,g] );

% Output the assignment decisions
output [
  "Assignment of students (Neighborhood, School, Group) and number of students:\n",
  concat([ "Neighborhood " ++ show(n) ++ ", School " ++ show(s) ++ ", Group " ++ show(g) ++ ": " 
           ++ show(x[n,s,g]) ++ "\n"
           | n in 1..N, s in 1..S, g in 1..G ])
];