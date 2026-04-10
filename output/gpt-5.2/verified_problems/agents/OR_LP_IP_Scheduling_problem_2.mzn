% Parameters
int: courses; % number of courses
int: periods; % number of periods
int: rooms;   % number of rooms available per period (capacity)

array[1..courses, 1..periods] of int: available; % 1 if course i can be scheduled in period j, else 0
array[1..courses, 1..courses] of int: conflict;  % 1 if course i conflicts with course k, else 0
array[1..courses] of int: requirement;           % required number of lectures for each course


% Variables
array[1..courses, 1..periods] of var 0..1: scheduled;
% scheduled[c,p] = 1 if one lecture of course c is scheduled in period p, else 0

array[1..periods] of var 0..rooms: used_rooms;
% used_rooms[p] = total number of scheduled lectures in period p (bounded by rooms)


% Constraints

% Link used_rooms to the total number of scheduled lectures in each period
constraint
  forall(p in 1..periods) (
    used_rooms[p] = sum(c in 1..courses)(scheduled[c, p])
  );

% Enforce per-period room capacity (redundant with used_rooms domain, but explicit)
constraint
  forall(p in 1..periods) (
    used_rooms[p] <= rooms
  );

% Respect course availability: can only schedule a course in periods where it is available
constraint
  forall(c in 1..courses, p in 1..periods) (
    scheduled[c, p] <= available[c, p]
  );

% Meet each course's lecture requirement exactly
constraint
  forall(c in 1..courses) (
    sum(p in 1..periods)(scheduled[c, p]) = requirement[c]
  );

% Conflict constraints: conflicting courses cannot be scheduled in the same period
constraint
  forall(c1 in 1..courses, c2 in c1+1..courses, p in 1..periods where conflict[c1, c2] = 1) (
    scheduled[c1, p] + scheduled[c2, p] <= 1
  );


% Objective
solve satisfy;