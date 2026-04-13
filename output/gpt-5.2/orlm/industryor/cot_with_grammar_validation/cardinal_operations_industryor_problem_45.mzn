int: N = 6;
int: D = 5;

set of int: Students = 1..N;
set of int: Days = 1..D;

set of int: UG = 1..4;
set of int: GR = 5..6;

int: Hday = 14;

array[Students] of int: wage10 = [100, 100, 99, 98, 108, 113];

array[Students, Days] of int: maxh =
[|
  6, 0, 6, 0, 7,
  0, 8, 9, 6, 0,
  4, 8, 3, 0, 5,
  5, 5, 6, 0, 4,
  3, 0, 5, 8, 0,
  0, 6, 0, 6, 5
|];

int: minUG = 8;
int: minGR = 7;

int: maxShiftsPerWeek = 2;
int: maxStudentsPerDay = 3;

array[Students, Days] of var 0..Hday: h;
array[Students, Days] of var 0..1: works;

constraint
  forall(s in Students, d in Days) (
    h[s,d] <= maxh[s,d]
  );

constraint
  forall(s in Students, d in Days) (
    h[s,d] <= Hday * works[s,d]
  );

constraint
  forall(s in Students, d in Days) (
    h[s,d] >= works[s,d]
  );

constraint
  forall(d in Days) (
    sum(s in Students)(h[s,d]) = Hday
  );

constraint
  forall(d in Days) (
    sum(s in Students)(works[s,d]) <= maxStudentsPerDay
  );

constraint
  forall(s in Students) (
    sum(d in Days)(works[s,d]) <= maxShiftsPerWeek
  );

constraint
  forall(s in UG) (
    sum(d in Days)(h[s,d]) >= minUG
  );

constraint
  forall(s in GR) (
    sum(d in Days)(h[s,d]) >= minGR
  );

var int: totalPay10 = sum(s in Students, d in Days)(wage10[s] * h[s,d]);

solve minimize totalPay10;