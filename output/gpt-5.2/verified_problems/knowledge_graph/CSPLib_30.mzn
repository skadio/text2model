include "globals.mzn";

int: n_courses;
int: n_periods;

int: load_per_period_lb;
int: load_per_period_ub;

int: courses_per_period_lb;
int: courses_per_period_ub;

array[1..n_courses] of int: course_load;

set of int: COURSES = 1..n_courses;
set of int: PERIODS = 1..n_periods;

% Decision: period assignment for each course
array[COURSES] of var PERIODS: period_of_course;

% Derived per-period counts and loads
array[PERIODS] of var 0..n_courses: courses_in_period =
  [sum(c in COURSES)(bool2int(period_of_course[c] == p)) | p in PERIODS];

int: total_load = sum(c in COURSES)(course_load[c]);
array[PERIODS] of var 0..total_load: load_in_period =
  [sum(c in COURSES)(course_load[c] * bool2int(period_of_course[c] == p)) | p in PERIODS];

% Bounds on number of courses per period
constraint forall(p in PERIODS)(
  courses_in_period[p] >= courses_per_period_lb /\
  courses_in_period[p] <= courses_per_period_ub
);

% Bounds on academic load per period
constraint forall(p in PERIODS)(
  load_in_period[p] >= load_per_period_lb /\
  load_in_period[p] <= load_per_period_ub
);

% Objective: minimize the maximum period load
var 0..total_load: max_load;
constraint max_load = max(p in PERIODS)(load_in_period[p]);

solve minimize max_load;

output [
  "max_load=", show(max_load), "\n",
  "period_of_course=", show(period_of_course), "\n",
  "courses_in_period=", show(courses_in_period), "\n",
  "load_in_period=", show(load_in_period), "\n"
];