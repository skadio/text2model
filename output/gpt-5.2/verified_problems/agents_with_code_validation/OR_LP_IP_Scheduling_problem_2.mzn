% Parameters
int: courses;                         % number of courses
int: periods;                         % number of periods (time slots)
int: rooms;                           % number of rooms available per period

set of int: COURSES = 1..courses;     % course index set
set of int: PERIODS = 1..periods;     % period index set

array[COURSES, PERIODS] of int: available;  % 1 if course c can be scheduled in period p, else 0
array[COURSES, COURSES] of int: conflict;   % 1 if courses c1 and c2 cannot overlap, else 0
array[COURSES] of int: requirement;         % required number of lectures for each course


% Variables
array[COURSES, PERIODS] of var 0..1: scheduled;      % 1 if a lecture of course c is scheduled in period p
array[COURSES] of var 0..periods: total_scheduled;   % total lectures scheduled per course


% Constraints

% Link helper variable to actual scheduled decisions (per course lecture count)
constraint
  forall(c in COURSES) (
    total_scheduled[c] = sum(p in PERIODS)(scheduled[c,p])
  );

% Each course must be scheduled for exactly its required number of lectures
constraint
  forall(c in COURSES) (
    total_scheduled[c] = requirement[c]
  );

% Respect availability: a course can only be scheduled in periods where it is available
constraint
  forall(c in COURSES, p in PERIODS) (
    scheduled[c,p] <= available[c,p]
  );

% Room capacity per period: at most 'rooms' lectures can be scheduled in the same period
constraint
  forall(p in PERIODS) (
    sum(c in COURSES)(scheduled[c,p]) <= rooms
  );

% Conflict constraints: conflicting courses cannot be scheduled in the same period
% (Enforce only for pairs (c1,c2) with c1 < c2 to avoid duplicates)
constraint
  forall(p in PERIODS, c1 in COURSES, c2 in COURSES where c1 < c2 /\ conflict[c1,c2] = 1) (
    scheduled[c1,p] + scheduled[c2,p] <= 1
  );


% Objective
solve satisfy;