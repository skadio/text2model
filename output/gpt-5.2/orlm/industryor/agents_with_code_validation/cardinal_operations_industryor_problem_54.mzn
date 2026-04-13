% Parameters

% Number of courses
int: nCourses = 7;

% Course index set
set of int: COURSES = 1..nCourses;

% Course names (for readability / output mapping)
array[COURSES] of string: courseName =
[
  "Calculus",
  "Operations Research",
  "Data Structures",
  "Management Statistics",
  "Computer Simulation",
  "Computer Programming",
  "Forecasting"
];

% Category index set: 1=Math, 2=OR, 3=CS
int: nCats = 3;
set of int: CATS = 1..nCats;

int: MATH = 1;
int: OR   = 2;
int: CS   = 3;

% Required number of courses per category
array[CATS] of int: req = [2, 2, 2];

% Membership matrix: belongs[c,cat]=true if course c counts toward category cat
array[COURSES, CATS] of bool: belongs =
array2d(COURSES, CATS,
[
  %               MATH    OR      CS
  /*1 Calculus*/   true,  false,  false,
  /*2 OR*/         true,  true,   false,
  /*3 DS*/         true,  false,  true,
  /*4 MS*/         true,  true,   false,
  /*5 Sim*/        false, true,   true,
  /*6 CP*/         false, false,  true,
  /*7 Fcst*/       true,  true,   false
]);

% Prerequisites as directed pairs (prereq -> target)
int: nPrereq = 4;
set of int: PR = 1..nPrereq;

array[PR] of int: prereqCourse = [6, 6, 1, 4];
array[PR] of int: targetCourse = [5, 3, 4, 7];


% Variables

% take[c]=1 if the student takes course c, else 0
array[COURSES] of var 0..1: take;

% total number of courses taken (objective variable)
var 0..nCourses: totalCourses;


% Constraints

% Link totalCourses to selected courses
constraint
  totalCourses = sum(c in COURSES)(take[c]);

% Category fulfillment constraints (courses may count for multiple categories)
constraint
  forall(cat in CATS)(
    sum(c in COURSES)(bool2int(belongs[c,cat]) * take[c]) >= req[cat]
  );

% Prerequisite constraints: if a target course is taken, its prerequisite must be taken
constraint
  forall(p in PR)(
    take[targetCourse[p]] <= take[prereqCourse[p]]
  );


% Objective
solve minimize totalCourses;