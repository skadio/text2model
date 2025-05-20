include "globals.mzn";

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
% Each course should have the required number of lectures
constraint forall(i in 1..courses)(
  sum(j in 1..periods)(schedule[i,j]) = requirement[i]
);

% No more than the available rooms should be used in any period
constraint forall(j in 1..periods)(
  sum(i in 1..courses)(schedule[i,j]) <= rooms
);

% Courses with conflicts should not be scheduled at the same time
constraint forall(i in 1..courses, j in i+1..courses, k in 1..periods)(
  if conflict[i,j] = 1 then
    schedule[i,k] + schedule[j,k] <= 1
  else
    true
  endif
);

% Courses should only be scheduled when they are available
constraint forall(i in 1..courses, j in 1..periods)(
  if available[i,j] = 0 then
    schedule[i,j] = 0
  else
    true
  endif
);

% Objective
% There is no specific objective mentioned in the problem description.
% However, we can add an objective to minimize the total number of periods used.
% This is just an example and may not be applicable in all cases.
var int: total_periods = sum(i in 1..courses, j in 1..periods)(schedule[i,j]);
solve minimize total_periods;

% Output
output [ "Schedule: ", show(schedule), "\nTotal periods used: ", show(total_periods) ];