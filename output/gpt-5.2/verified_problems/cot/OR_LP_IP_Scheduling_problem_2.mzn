% Parameters
int: courses;
int: periods;
int: rooms;

array[1..courses, 1..periods] of int: available;   % 0/1
array[1..courses, 1..courses] of int: conflict;    % 0/1
array[1..courses] of int: requirement;

% Variables
array[1..courses, 1..periods] of var 0..1: x;      % x[c,p]=1 if a lecture of course c is scheduled in period p

% Constraints
constraint forall(c in 1..courses, p in 1..periods) (
  x[c,p] <= available[c,p]
);

constraint forall(c in 1..courses) (
  sum(p in 1..periods)(x[c,p]) = requirement[c]
);

constraint forall(p in 1..periods) (
  sum(c in 1..courses)(x[c,p]) <= rooms
);

constraint forall(p in 1..periods, i in 1..courses, j in i+1..courses where conflict[i,j] = 1) (
  x[i,p] + x[j,p] <= 1
);

% Objective
solve satisfy;