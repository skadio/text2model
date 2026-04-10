% Parameters
int: n_courses; % number of courses
int: n_periods; % number of academic periods

int: load_per_period_lb; % minimum academic load allowed per period
int: load_per_period_ub; % maximum academic load allowed per period

int: courses_per_period_lb; % minimum number of courses allowed per period
int: courses_per_period_ub; % maximum number of courses allowed per period

array[1..n_courses] of int: course_load; % load (credits) of each course

% Helpful index sets
set of int: COURSES = 1..n_courses;
set of int: PERIODS = 1..n_periods;


% Variables
array[COURSES] of var PERIODS: course_period; % assigned period for each course

array[PERIODS] of var 0..n_courses: courses_in_period; % number of courses scheduled in each period
array[PERIODS] of var 0..sum(course_load): load_in_period; % total load scheduled in each period

var load_per_period_lb..load_per_period_ub: max_period_load; % maximum load across all periods (objective variable)


% Constraints

% --- Link derived counts/loads to course assignments ---
constraint
  forall(p in PERIODS) (
    % number of courses assigned to period p
    courses_in_period[p] = sum(c in COURSES)(bool2int(course_period[c] = p))
  );

constraint
  forall(p in PERIODS) (
    % total academic load assigned to period p
    load_in_period[p] = sum(c in COURSES)(course_load[c] * bool2int(course_period[c] = p))
  );

% --- Per-period bounds on number of courses ---
constraint
  forall(p in PERIODS) (
    courses_per_period_lb <= courses_in_period[p] /\
    courses_in_period[p] <= courses_per_period_ub
  );

% --- Per-period bounds on load ---
constraint
  forall(p in PERIODS) (
    load_per_period_lb <= load_in_period[p] /\
    load_in_period[p] <= load_per_period_ub
  );

% --- Define the maximum load variable (used by the objective) ---
% Redundant but tightening: max_period_load is an upper bound on each period's load
constraint
  forall(p in PERIODS) (
    load_in_period[p] <= max_period_load
  );

% Ensure max_period_load equals the maximum of period loads
constraint
  max_period_load = max(p in PERIODS)(load_in_period[p]);


% Objective
solve minimize max_period_load;