int: N = 7;
set of int: COURSES = 1..N;

int: M = 3;
set of int: CATS = 1..M;
int: MATH = 1;
int: OR   = 2;
int: CS   = 3;

array[COURSES] of string: cname = [
  "Calculus",
  "Operations Research",
  "Data Structures",
  "Management Statistics",
  "Computer Simulation",
  "Computer Programming",
  "Forecasting"
];

array[CATS, COURSES] of bool: inCat = array2d(CATS, COURSES, [
  true,  true,  true,  true, false, false,  true,
  false,  true, false,  true,  true, false,  true,
  false, false,  true, false,  true,  true, false
]);

int: P = 4;
set of int: PR = 1..P;
array[PR] of int: prereq = [6, 6, 1, 4];
array[PR] of int: course  = [5, 3, 4, 7];

int: reqMath = 2;
int: reqOR   = 2;
int: reqCS   = 2;

array[COURSES] of var 0..1: take;
var 0..N: total;

constraint total = sum(c in COURSES)(take[c]);

constraint sum(c in COURSES)(bool2int(inCat[MATH,c]) * take[c]) >= reqMath;
constraint sum(c in COURSES)(bool2int(inCat[OR,c])   * take[c]) >= reqOR;
constraint sum(c in COURSES)(bool2int(inCat[CS,c])   * take[c]) >= reqCS;

constraint forall(p in PR)(
  take[course[p]] <= take[prereq[p]]
);

solve minimize total;

output [
  "total=", show(total), "\n",
  "courses=", show([cname[c] | c in COURSES where take[c] = 1]), "\n"
];