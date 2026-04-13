% Parameters
int: N = 7;
set of int: COURSES = 1..N;

% Course indices
int: CALC = 1;
int: OR   = 2;
int: DS   = 3;
int: MS   = 4;
int: SIM  = 5;
int: CP   = 6;
int: FC   = 7;

set of int: C_MATH = {CALC, OR, DS, MS, FC};
set of int: C_OR   = {OR, MS, SIM, FC};
set of int: C_CS   = {CP, DS, SIM};

int: REQ_MATH = 2;
int: REQ_OR   = 2;
int: REQ_CS   = 2;

% Prerequisites: if a course is taken, all in its prereq set must be taken
array[COURSES] of set of int: prereq =
[
  {},          % CALC
  {},          % OR
  {CP},        % DS requires CP
  {CALC},      % MS requires CALC
  {CP},        % SIM requires CP
  {},          % CP
  {MS}         % FC requires MS
];

% Variables
array[COURSES] of var 0..1: take;
var 0..N: total_courses;

% Constraints
constraint total_courses = sum(c in COURSES)(take[c]);

constraint sum(c in C_MATH)(take[c]) >= REQ_MATH;
constraint sum(c in C_OR)(take[c])   >= REQ_OR;
constraint sum(c in C_CS)(take[c])   >= REQ_CS;

constraint forall(c in COURSES)(
  take[c] = 1 -> forall(p in prereq[c])(take[p] = 1)
);

% Objective
solve minimize total_courses;