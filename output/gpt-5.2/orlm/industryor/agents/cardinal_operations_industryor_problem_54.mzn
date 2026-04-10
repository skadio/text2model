% Parameters
% Problem is fully specified in the description, so we embed all data here.

% Courses (fixed list of 7)
int: nCourses = 7;
set of int: COURSES = 1..nCourses;

% Course indices (for readability)
int: CALC = 1;
int: OR   = 2;
int: DS   = 3;
int: MS   = 4;
int: CSIM = 5;
int: CP   = 6;
int: FCST = 7;

% Category indices
int: nCats = 3;
set of int: CATS = 1..nCats;
int: MATH  = 1;
int: ORCAT = 2;
int: CSCAT = 3;

% Required counts per category: 2 Math, 2 OR, 2 CS
array[CATS] of int: req = [2, 2, 2];

% Category membership matrix:
% belongs[c, k] = true if course c can count for category k
array[COURSES, CATS] of bool: belongs =
  %          MATH   OR     CS
  [|          true, false, false  % Calculus
   |          true, true,  false  % Operations Research
   |          true, false, true   % Data Structures
   |          true, true,  false  % Management Statistics
   |          false,true,  true   % Computer Simulation
   |          false,false, true   % Computer Programming
   |          true, true,  false  % Forecasting
  |];

% Prerequisites (prereq[p, c] = true means: if take c then must take p)
% Given:
%  - CSIM or DS requires CP
%  - MS requires CALC
%  - FCST requires MS
array[COURSES, COURSES] of bool: prereq =
  [| false,false,false,false,false,false,false  % CALC
   | false,false,false,false,false,false,false  % OR
   | false,false,false,false,false,true, false  % DS  <- CP
   | true, false,false,false,false,false,false  % MS  <- CALC
   | false,false,false,false,false,true, false  % CSIM<- CP
   | false,false,false,false,false,false,false  % CP
   | false,false,false,true, false,false,false  % FCST<- MS
  |];

% Variables
% take[c] = 1 if the student takes course c, else 0
array[COURSES] of var 0..1: take;

% Total number of courses taken (objective)
var 0..nCourses: totalCourses;


% Constraints

% Link totalCourses to the number of selected courses
constraint
  totalCourses = sum(c in COURSES)(take[c]);

% Category coverage requirements:
% Each selected course can contribute to every category it belongs to (simultaneously).
constraint
  forall(k in CATS)(
    sum(c in COURSES)(take[c] * bool2int(belongs[c, k])) >= req[k]
  );

% Prerequisite enforcement:
% If a course is taken, all its prerequisites must also be taken.
constraint
  forall(p in COURSES, c in COURSES where prereq[p, c])(
    take[c] <= take[p]
  );


% Objective
solve minimize totalCourses;