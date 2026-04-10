include "globals.mzn";

%----------------------%
% Input data (.dzn)    %
%----------------------%
int: n_courses;
int: n_periods;

int: load_per_period_lb;
int: load_per_period_ub;

int: courses_per_period_lb;
int: courses_per_period_ub;

array[1..n_courses] of int: course_load;

%----------------------%
% Decision variables   %
%----------------------%
array[1..n_courses] of var 1..n_periods: period_of_course;

% Derived counts and loads per period
array[1..n_periods] of var 0..n_courses: n_courses_in_period;
array[1..n_periods] of var 0..sum(course_load): load_in_period;

% Objective: minimize the maximum load of any period
var 0..sum(course_load): max_period_load;

%----------------------%
% Constraints          %
%----------------------%

% Course count per period bounds (from hint using count)
constraint forall(p in 1..n_periods) (
  count(period_of_course, p, n_courses_in_period[p]) /\
  n_courses_in_period[p] >= courses_per_period_lb /\
  n_courses_in_period[p] <= courses_per_period_ub
);

% Load per period (sum of loads of courses assigned to that period)
constraint forall(p in 1..n_periods) (
  load_in_period[p] = sum(c in 1..n_courses)( course_load[c] * bool2int(period_of_course[c] = p) )
);

% Load bounds per period
constraint forall(p in 1..n_periods) (
  load_in_period[p] >= load_per_period_lb /\
  load_in_period[p] <= load_per_period_ub
);

% Define maximum period load
constraint max_period_load = max(p in 1..n_periods)(load_in_period[p]);

%----------------------%
% Solve                %
%----------------------%
solve minimize max_period_load;

%----------------------%
% Output               %
%----------------------%
output [
  "period_of_course = ", show(period_of_course), ";\n",
  "n_courses_in_period = ", show(n_courses_in_period), ";\n",
  "load_in_period = ", show(load_in_period), ";\n",
  "max_period_load = ", show(max_period_load), ";\n"
];