% Parameters
int: courses;
int: periods;
int: rooms;
array[1..courses,1..periods] of int: available;
array[1..courses,1..courses] of int: conflict;
array[1..courses] of int: requirement;

% Variables
array[1..courses,1..periods] of var 0..1: schedule;

% Constraints
% Course lecture requirement
constraint forall(i in 1..courses) (
    sum(j in 1..periods)(schedule[i,j]) == requirement[i]
);

% Period capacity (rooms)
constraint forall(j in 1..periods) (
    sum(i in 1..courses)(schedule[i,j]) <= rooms
);

% Conflict constraints
constraint forall(i in 1..courses, k in i+1..courses, j in 1..periods) (
    (conflict[i,k] == 1) -> (schedule[i,j] + schedule[k,j] <= 1)
);

% Availability constraints
constraint forall(i in 1..courses, j in 1..periods) (
    schedule[i,j] <= available[i,j]
);

% Objective
solve satisfy;