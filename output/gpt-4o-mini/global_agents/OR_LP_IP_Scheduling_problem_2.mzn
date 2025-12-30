include "globals.mzn";

int: courses;                             % Number of courses
int: periods;                             % Number of periods
int: rooms;                               % Number of rooms available
array[1..courses, 1..periods] of int: available; % Availability matrix
array[1..courses, 1..courses] of int: conflict;  % Conflict matrix
array[1..courses] of int: requirement;   % Number of lectures required per course
int: max_lectures_per_period;            % Maximum lectures that can be scheduled per period

/* Variables */
array[1..courses] of var 0..periods: start;   % Start time for each course's lectures
array[1..courses] of var 1..periods: duration;  % Duration for each course's lectures
array[1..courses] of int: usage = [1 | i in 1..courses]; % Each course uses 1 room

/* Constraints */
% Cumulative constraint to ensure no more than max_lectures_per_period lectures are scheduled at the same time
constraint cumulative(start, duration, usage, max_lectures_per_period);

/* Ensure that lectures are scheduled only in available periods */
constraint forall(i in 1..courses)(
    sum(j in 1..periods)( (available[i,j] == 1) -> (start[i] <= j) /\ (j < start[i] + duration[i]) ) ) == requirement[i]
);

/* Ensure that conflicting courses are not scheduled at the same time */
constraint forall(i, j in 1..courses where i < j)(
    conflict[i,j] == 1 -> (start[i] + duration[i] <= start[j] \/ start[j] + duration[j] <= start[i])
);

/* Solve & output */
solve satisfy;
output [ "Start times = ", show(start), "\nDurations = ", show(duration), "\n" ];