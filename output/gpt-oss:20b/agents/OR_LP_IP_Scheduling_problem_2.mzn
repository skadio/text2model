include "globals.mzn";

/* ----- Input data ----- */
int: courses;                     % number of courses
int: periods;                     % number of periods
int: rooms;                       % number of rooms

array[1..courses, 1..periods] of int: available;   % 1 if course i can be scheduled at period p
array[1..courses, 1..courses] of int: conflict;    % 1 if courses i and j conflict
array[1..courses] of int: requirement;             % required number of lectures per course

/* ----- Decision variables ----- */
array[1..courses, 1..periods] of var 0..1: x;       % x[i,p] = 1 iff course i has a lecture in period p

/* ----- Constraints ----- */

/* 1. Each course must have the required number of lectures */
constraint
  forall(i in 1..courses)(
    sum(p in 1..periods)( x[i,p] ) = requirement[i]
  );

/* 2. Lectures can only be scheduled at available times */
constraint
  forall(i in 1..courses, p in 1..periods)(
    x[i,p] <= available[i,p]
  );

/* 3. Capacity of each period (no more than `rooms` lectures) */
constraint
  forall(p in 1..periods)(
    sum(i in 1..courses)( x[i,p] ) <= rooms
  );

/* 4. Conflicting courses cannot share a period */
constraint
  forall(i in 1..courses, j in i+1..courses, p in 1..periods)(
    conflict[i,j] == 1 -> x[i,p] + x[j,p] <= 1
  );

/* ----- Solve ----- */
solve satisfy;

/* ----- Output ----- */
output [
  "Schedule (rows = courses, columns = periods):\n",
  concat([ show([x[i,p] | p in 1..periods]) ++ "\n" | i in 1..courses ])
];