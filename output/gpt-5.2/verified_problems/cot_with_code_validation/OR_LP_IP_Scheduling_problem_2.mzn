% Timetable (satisfaction)

% Parameters
int: courses;
int: periods;
int: rooms;

array[1..courses, 1..periods] of int: available;  % 0/1
array[1..courses, 1..courses] of int: conflict;   % 0/1
array[1..courses] of int: requirement;

% Decision variables
array[1..courses, 1..periods] of var 0..1: x; % x[i,p]=1 if course i is scheduled in period p

% Availability constraints
constraint
  forall(i in 1..courses, p in 1..periods) (
    x[i,p] <= available[i,p]
  );

% Each course must meet its lecture requirement
constraint
  forall(i in 1..courses) (
    sum(p in 1..periods)(x[i,p]) = requirement[i]
  );

% Room capacity per period
constraint
  forall(p in 1..periods) (
    sum(i in 1..courses)(x[i,p]) <= rooms
  );

% Conflicts: conflicting courses cannot be in the same period
constraint
  forall(p in 1..periods, i in 1..courses, j in i+1..courses) (
    conflict[i,j] = 0 \/ (x[i,p] + x[j,p] <= 1)
  );

solve satisfy;