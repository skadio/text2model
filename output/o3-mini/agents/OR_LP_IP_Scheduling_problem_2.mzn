include "globals.mzn";

% Parameters (provided via the .dzn file)
int: courses;
int: periods;
int: rooms;
array[1..courses, 1..periods] of int: available;   % 1 if course i is available in period j, 0 otherwise
array[1..courses, 1..courses] of int: conflict;      % 1 if courses i and j conflict, 0 otherwise
array[1..courses] of int: requirement;              % number of lectures required for each course

% Decision variable:
% scheduled[i,j] = 1 if course i has a lecture scheduled in period j, 0 otherwise
array[1..courses, 1..periods] of var 0..1: scheduled;

% Constraint 1: Each course must have exactly the required number of lectures scheduled.
constraint
  forall(i in 1..courses) (
    count(scheduled[i, 1..periods], 1, requirement[i])
  );

% Constraint 2: Lectures can only be scheduled in periods where the course is available.
constraint
  forall(i in 1..courses, j in 1..periods) (
    scheduled[i,j] <= available[i,j]
  );

% Constraint 3: Conflicting courses cannot have lectures in the same period.
constraint
  forall(j in 1..periods, i in 1..courses, k in i+1..courses) (
    conflict[i,k] = 1 -> (scheduled[i,j] + scheduled[k,j] <= 1)
  );

% Constraint 4: Limit the total number of lectures in any period to the number of available rooms.
constraint
  forall(j in 1..periods) (
    sum(i in 1..courses)( scheduled[i,j] ) <= rooms
  );

% Solve: find any assignment satisfying all constraints.
solve satisfy;

% Output scheduled matrix.
output [
  "Schedule (rows: courses, columns: periods):\n",
  concat([ show([ scheduled[i,j] | j in 1..periods ]) ++ "\n" | i in 1..courses ])
];