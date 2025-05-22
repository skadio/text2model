% Parameters
int: courses;
int: periods;
int: rooms;
array[1..courses, 1..periods] of 0..1: available;
array[1..courses, 1..courses] of 0..1: conflict;
array[1..courses] of int: requirement;

% Variables
array[1..courses, 1..periods] of var 0..rooms: schedule;

% Constraints
% Each course should be scheduled for the required number of lectures
constraint forall(i in 1..courses)(
  sum(j in 1..periods)(schedule[i,j]) = requirement[i]
);

% No course should be scheduled at a period when it's not available
constraint forall(i in 1..courses, j in 1..periods)(
  schedule[i,j] <= available[i,j] * rooms
);

% No two conflicting courses should be scheduled at the same period
constraint forall(i in 1..courses, j in i+1..courses, k in 1..periods)(
  if conflict[i,j] = 1 then
    schedule[i,k] + schedule[j,k] <= rooms
  endif
);

% The number of lectures scheduled in each period should not exceed the number of rooms
constraint forall(j in 1..periods)(
  sum(i in 1..courses)(schedule[i,j]) <= rooms
);

% Objective
% As this is a feasibility problem, we don't have an objective to optimize.
solve satisfy;