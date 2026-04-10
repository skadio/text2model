% Parameters
int: n_courses;                     % number of courses
int: n_periods;                     % number of academic periods

int: load_per_period_lb;            % minimum total load allowed in a period
int: load_per_period_ub;            % maximum total load allowed in a period

int: courses_per_period_lb;         % minimum number of courses allowed in a period
int: courses_per_period_ub;         % maximum number of courses allowed in a period

array[1..n_courses] of int: course_load;   % load/credits for each course

% Useful index sets
set of int: COURSES = 1..n_courses;
set of int: PERIODS = 1..n_periods;

% Variables
array[COURSES] of var PERIODS: period_of_course;  % assigned period for each course

array[PERIODS] of var int: period_load;           % total load in each period
array[PERIODS] of var int: period_ncourses;       % number of courses in each period

var int: max_period_load;                         % maximum load across all periods (to minimize)

% Constraints

% Link aggregate variables (period_load, period_ncourses) to the course assignments
constraint
  forall(p in PERIODS) (
    period_load[p] =
      sum(c in COURSES) ( course_load[c] * bool2int(period_of_course[c] = p) )
  );

constraint
  forall(p in PERIODS) (
    period_ncourses[p] =
      sum(c in COURSES) ( bool2int(period_of_course[c] = p) )
  );

% Enforce load bounds per period
constraint
  forall(p in PERIODS) (
    load_per_period_lb <= period_load[p] /\
    period_load[p] <= load_per_period_ub
  );

% Enforce course-count bounds per period
constraint
  forall(p in PERIODS) (
    courses_per_period_lb <= period_ncourses[p] /\
    period_ncourses[p] <= courses_per_period_ub
  );

% Define max_period_load as an upper bound on each period load (objective-related variable)
constraint
  forall(p in PERIODS) (
    period_load[p] <= max_period_load
  );

% Objective
solve minimize max_period_load;