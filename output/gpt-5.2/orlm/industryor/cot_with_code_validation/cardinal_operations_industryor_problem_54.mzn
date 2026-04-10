% Courses: 1..7
int: N = 7;
set of int: COURSES = 1..N;

int: CALCULUS = 1;
int: OPERATIONS_RESEARCH = 2;
int: DATA_STRUCTURES = 3;
int: MANAGEMENT_STATISTICS = 4;
int: COMPUTER_SIMULATION = 5;
int: COMPUTER_PROGRAMMING = 6;
int: FORECASTING = 7;

% Categories: 1=Math, 2=OR, 3=CS
int: NCAT = 3;
set of int: CATS = 1..NCAT;
int: MATH = 1;
int: ORCAT = 2;
int: CSCAT = 3;

array[CATS] of int: req = [2, 2, 2];

% belongs[c,cat] indicates whether course c counts for category cat
array[COURSES, CATS] of bool: belongs =
array2d(COURSES, CATS,
[
  % Calculus
  true,  false, false,
  % Operations Research
  true,  true,  false,
  % Data Structures
  true,  false, true,
  % Management Statistics
  true,  true,  false,
  % Computer Simulation
  false, true,  true,
  % Computer Programming
  false, false, true,
  % Forecasting
  true,  true,  false
]);

% prerequisite pairs (pre -> post)
int: P = 4;
set of int: PR = 1..P;
array[PR] of int: pre  = [COMPUTER_PROGRAMMING, COMPUTER_PROGRAMMING, CALCULUS, MANAGEMENT_STATISTICS];
array[PR] of int: post = [COMPUTER_SIMULATION,  DATA_STRUCTURES,     MANAGEMENT_STATISTICS, FORECASTING];

% Decision variables
array[COURSES] of var 0..1: take;
var 0..N: total_courses;

% Total courses taken
constraint total_courses = sum(c in COURSES)(take[c]);

% Category requirements (a course may count in multiple categories)
constraint
  forall(cat in CATS)(
    sum(c in COURSES)(bool2int(belongs[c,cat]) * take[c]) >= req[cat]
  );

% Prerequisites
constraint
  forall(p in PR)(
    take[post[p]] <= take[pre[p]]
  );

solve minimize total_courses;

output [
  "Minimum courses = ", show(total_courses), "\n",
  "Take: ",
  concat([ if fix(take[c]) = 1 then show(c) ++ " " else "" endif | c in COURSES ]),
  "\n"
];