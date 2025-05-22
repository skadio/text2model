% Parameters
int: courses;
int: periods;
int: rooms;

array[1..courses, 1..periods] of 0..1: available;
array[1..courses, 1..courses] of 0..1: conflict;
array[1..courses] of int: requirement;

% Variables
array[1..courses, 1..periods] of var 0..1: x;   % x[i,p] = 1 if course i has a lecture in period p

% Constraints
% Availability
constraint
  forall(i in 1..courses, p in 1..periods) (
    available[i,p] = 0 -> x[i,p] = 0
  );

% Lecture requirement per course
constraint
  forall(i in 1..courses) (
    sum(p in 1..periods)(x[i,p]) = requirement[i]
  );

% Period capacity (rooms)
constraint
  forall(p in 1..periods) (
    sum(i in 1..courses)(x[i,p]) <= rooms
  );

% Conflict constraints
constraint
  forall(i,j in 1..courses where i < j /\ conflict[i,j] = 1, p in 1..periods) (
    x[i,p] + x[j,p] <= 1
  );

% Objective
solve satisfy;