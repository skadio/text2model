include "globals.mzn";

int: n_courses;                          % Number of courses
int: n_periods;                           % Number of periods
array[1..n_courses] of int: course_load; % Load of each course

int: load_per_period_lb;                 % Lower bound for load per period
int: load_per_period_ub;                 % Upper bound for load per period
int: courses_per_period_lb;               % Lower bound for number of courses per period
int: courses_per_period_ub;               % Upper bound for number of courses per period

/* Variables */
array[1..n_periods] of var 0..n_courses: course_count;  % Number of courses in each period
array[1..n_periods] of var int: period_load;            % Total load for each period
array[1..n_courses] of var 1..n_periods: course_assignment; % Course assignments to periods

/* Constraints */
constraint global_cardinality(course_assignment, 1..n_periods, course_count);

/* Calculate the load for each period */
constraint forall(p in 1..n_periods)(
    period_load[p] = sum(i in 1..n_courses)(course_load[i] * (course_assignment[i] == p ? 1 : 0))
);

/* Ensure load per period is within bounds */
constraint forall(p in 1..n_periods)(
    period_load[p] >= load_per_period_lb /\ period_load[p] <= load_per_period_ub
);

/* Ensure the number of courses per period is within bounds */
constraint count(course_count, courses_per_period_lb, courses_per_period_ub);

/* Objective: Minimize the maximum load across all periods */
var int: max_load = max(period_load);
solve minimize max_load;

/* Output */
output [ "Course Assignments = ", show(course_assignment), "\n",
         "Period Loads = ", show(period_load), "\n",
         "Max Load = ", show(max_load), "\n" ];