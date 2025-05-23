% Parameters
int: courses;
int: periods;
int: rooms;

array[1..courses, 1..periods] of int: available;        % 1 if course i can be taught in period j
array[1..courses, 1..courses] of int: conflict;         % 1 if courses i and k share students
array[1..courses] of int: requirement;                  % required number of lectures for each course

% Variables
array[1..courses, 1..periods] of var 0..1: lecture;     % 1 if course i is scheduled in period j

% Constraints
% 1. Respect course availability
constraint
  forall(i in 1..courses, j in 1..periods where available[i,j] = 0) (
    lecture[i,j] = 0
  );

% 2. Meet the exact lecture requirement for every course
constraint
  forall(i in 1..courses) (
    sum(j in 1..periods)(lecture[i,j]) = requirement[i]
  );

% 3. Do not exceed room capacity in any period
constraint
  forall(j in 1..periods) (
    sum(i in 1..courses)(lecture[i,j]) <= rooms
  );

% 4. Conflicting courses cannot be scheduled simultaneously
constraint
  forall(i, k in 1..courses where i < k /\ conflict[i,k] = 1) (
    forall(j in 1..periods) (
      lecture[i,j] + lecture[k,j] <= 1
    )
  );

% Objective
solve satisfy;