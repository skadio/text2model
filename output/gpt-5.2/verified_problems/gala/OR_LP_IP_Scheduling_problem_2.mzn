include "globals.mzn";

%----------------------------
% Input data (from .dzn)
%----------------------------
int: courses;
int: periods;
int: rooms;

array[1..courses, 1..periods] of int: available;   % 1 if course c can be scheduled in period p
array[1..courses, 1..courses] of int: conflict;    % 1 if courses c1 and c2 cannot overlap
array[1..courses] of int: requirement;             % number of lectures required per course

%----------------------------
% Decision variables
%----------------------------
% x[c,p] = 1 if course c has a lecture scheduled in period p (at most one per course per period)
array[1..courses, 1..periods] of var 0..1: x;

%----------------------------
% Constraints
%----------------------------

% Availability: only schedule where allowed
constraint
  forall(c in 1..courses, p in 1..periods)(
    x[c,p] <= available[c,p]
  );

% Each course must have exactly its required number of lectures
constraint
  forall(c in 1..courses)(
    count([x[c,p] | p in 1..periods], 1, requirement[c])
  );

% Conflicts: conflicting courses cannot be scheduled in the same period
constraint
  forall(p in 1..periods, c1 in 1..courses, c2 in c1+1..courses where conflict[c1,c2] = 1)(
    x[c1,p] + x[c2,p] <= 1
  );

% Room capacity / period load: at most 'rooms' lectures in any period
constraint
  forall(p in 1..periods)(
    sum(c in 1..courses)(x[c,p]) <= rooms
  );

%----------------------------
% Solve
%----------------------------
solve satisfy;

%----------------------------
% Output
%----------------------------
output [
  "x (courses x periods) = \n",
  show(x), "\n",
  "Period loads = ", show([sum(c in 1..courses)(x[c,p]) | p in 1..periods]), "\n"
];