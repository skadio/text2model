include "globals.mzn";

% Input parameters
int: n_courses;
int: n_periods;
int: load_per_period_lb;
int: load_per_period_ub;
int: courses_per_period_lb;
int: courses_per_period_ub;
array[1..n_courses] of int: course_load;

% Decision variable: assign each course to a period (1..n_periods)
array[1..n_courses] of var 1..n_periods: course_period;

% Enforce that the number of courses per period is within the given bounds.
array[1..n_periods] of int: lo_courses = [ courses_per_period_lb | p in 1..n_periods ];
array[1..n_periods] of int: up_courses = [ courses_per_period_ub | p in 1..n_periods ];
constraint global_cardinality_low_up(course_period, 1..n_periods, lo_courses, up_courses);

% Calculate the academic load of each period
array[1..n_periods] of var int: period_load;
constraint
    forall(p in 1..n_periods)(
         period_load[p] = sum(c in 1..n_courses)( if course_period[c] == p then course_load[c] else 0 endif )
    );

% Enforce that each period's load is within the prescribed lower and upper bounds.
constraint
    forall(p in 1..n_periods)(
         period_load[p] >= load_per_period_lb /\ period_load[p] <= load_per_period_ub
    );

% Define a variable to represent the maximum load across all periods.
var int: max_load;
constraint max_load = max(p in 1..n_periods)( period_load[p] );

% Objective: minimize the maximum courseload among all periods.
solve minimize max_load;

% Output the course assignments, computed period loads, and the maximum load.
output [
    "Course Period Assignment: ", show(course_period), "\n",
    "Period Loads: ", show(period_load), "\n",
    "Maximum Load: ", show(max_load), "\n"
];