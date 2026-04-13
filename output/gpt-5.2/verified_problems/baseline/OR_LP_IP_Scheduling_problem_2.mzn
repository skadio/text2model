int: courses;
int: periods;
int: rooms;

array[1..courses, 1..periods] of int: available; % 0/1
array[1..courses, 1..courses] of int: conflict;  % 0/1 (typically symmetric)
array[1..courses] of int: requirement;

array[1..courses, 1..periods] of var 0..1: x; % x[c,p]=1 if a lecture of course c is scheduled in period p

% Availability: can only schedule where available=1
constraint
  forall(c in 1..courses, p in 1..periods) (
    x[c,p] <= available[c,p]
  );

% Requirement: each course must have exactly its required number of lectures across all periods
constraint
  forall(c in 1..courses) (
    sum(p in 1..periods)(x[c,p]) = requirement[c]
  );

% Room capacity: at most 'rooms' lectures in any period
constraint
  forall(p in 1..periods) (
    sum(c in 1..courses)(x[c,p]) <= rooms
  );

% Conflicts: conflicting courses cannot be scheduled in the same period
constraint
  forall(c1 in 1..courses, c2 in c1+1..courses, p in 1..periods where conflict[c1,c2] = 1 \/ conflict[c2,c1] = 1) (
    x[c1,p] + x[c2,p] <= 1
  );

solve satisfy;

output [
  "x (courses x periods):\n"
] ++
[
  if p = 1 then "course " ++ show(c) ++ ": " else "" endif ++
  show(x[c,p]) ++ if p = periods then "\n" else " " endif
  | c in 1..courses, p in 1..periods
];