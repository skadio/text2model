int: n_courses;
int: n_periods;

int: load_per_period_lb;
int: load_per_period_ub;

int: courses_per_period_lb;
int: courses_per_period_ub;

array[1..n_courses] of int: course_load;

set of int: COURSES = 1..n_courses;
set of int: PERIODS = 1..n_periods;

array[COURSES] of var PERIODS: period_of_course;

array[PERIODS] of var int: period_load =
  [ sum(c in COURSES)(course_load[c] * bool2int(period_of_course[c] == p)) | p in PERIODS ];

array[PERIODS] of var int: period_ncourses =
  [ sum(c in COURSES)(bool2int(period_of_course[c] == p)) | p in PERIODS ];

constraint forall(p in PERIODS)(
  load_per_period_lb <= period_load[p] /\ period_load[p] <= load_per_period_ub
);

constraint forall(p in PERIODS)(
  courses_per_period_lb <= period_ncourses[p] /\ period_ncourses[p] <= courses_per_period_ub
);

var int: max_period_load = max(p in PERIODS)(period_load[p]);

solve minimize max_period_load;

output [
  "max_period_load=", show(max_period_load), "\n",
  "period_of_course=", show(period_of_course), "\n",
  "period_load=", show(period_load), "\n",
  "period_ncourses=", show(period_ncourses), "\n"
];