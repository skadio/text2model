int: courses;
int: periods;
int: rooms;

array[1..courses, 1..periods] of int: available; % 0/1
array[1..courses, 1..courses] of int: conflict; % 0/1
array[1..courses] of int: requirement;

set of int: C = 1..courses;
set of int: P = 1..periods;

array[C, P] of var 0..1: x; % x[c,p]=1 if a lecture of course c is scheduled in period p

% Availability: can only schedule where available=1
constraint
  forall(c in C, p in P) (
    x[c,p] <= available[c,p]
  );

% Course lecture requirements: schedule exactly requirement[c] lectures for each course
constraint
  forall(c in C) (
    sum(p in P)(x[c,p]) = requirement[c]
  );

% Room capacity per period: at most 'rooms' lectures scheduled concurrently
constraint
  forall(p in P) (
    sum(c in C)(x[c,p]) <= rooms
  );

% Conflicts: conflicting courses cannot be scheduled in the same period
constraint
  forall(c1 in C, c2 in C where c1 < c2 /\ conflict[c1,c2] = 1) (
    forall(p in P) (
      x[c1,p] + x[c2,p] <= 1
    )
  );

solve satisfy;

output [
  "x (courses x periods) =\n",
  concat([ concat([ if fix(x[c,p]) = 1 then "1 " else "0 " endif | p in P ]) ++ "\n" | c in C ])
];