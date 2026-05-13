include "globals.mzn";

/*--- Data ---*/
int: n_courses;
int: n_periods;
int: load_per_period_lb;
int: load_per_period_ub;
int: courses_per_period_lb;
int: courses_per_period_ub;
array[1..n_courses] of int: course_load;

/*--- Decision variables ---*/
array[1..n_courses] of var 1..n_periods: period;           % assignment of each course
array[1..n_periods] of var 0..n_courses: occ;              % number of courses per period
array[1..n_periods] of var int: load;                      % load of each period
var int: maxLoad;                                          % maximum period load

/*--- Constraints ---*/
/* number of courses per period bounds */
constraint
  forall(p in 1..n_periods) (
    count(period, p, occ[p]) /\
    occ[p] >= courses_per_period_lb /\
    occ[p] <= courses_per_period_ub
  );

/* load per period bounds */
constraint
  forall(p in 1..n_periods) (
    load[p] = sum(i in 1..n_courses) (course_load[i] * bool2int(period[i] == p)) /\
    load[p] >= load_per_period_lb /\
    load[p] <= load_per_period_ub
  );

/* define maximum load */
constraint maxLoad = max(load);

/*--- Objective ---*/
solve minimize maxLoad;

/*--- Output ---*/
output [
  "Period assignment: ", show(period), "\n",
  "Load per period: ", show(load), "\n",
  "Courses per period: ", show(occ), "\n",
  "Maximum load: ", show(maxLoad), "\n"
];