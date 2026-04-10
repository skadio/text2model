int: S = 6;
int: U = 4;
int: D = 5;
int: H = 14;

set of int: Students = 1..S;
set of int: Undergrads = 1..U;
set of int: Grads = (U+1)..S;
set of int: Days = 1..D;
set of int: Hours = 1..H;

array[Students] of int: wageInt = [100, 100, 99, 98, 108, 113];

array[Students, Days] of int: maxAvail =
  [| 6, 0, 6, 0, 7
   | 0, 8, 9, 6, 0
   | 4, 8, 3, 0, 5
   | 5, 5, 6, 0, 4
   | 3, 0, 5, 8, 0
   | 0, 6, 0, 6, 5 |];

int: minWeeklyU = 8;
int: minWeeklyG = 7;
int: maxShiftsPerWeek = 2;
int: maxStudentsPerDay = 3;

array[Students, Days, Hours] of var bool: x;
array[Students, Days] of var bool: y;

var int: totalPay10;

constraint forall(d in Days, h in Hours) (
  sum(s in Students)(bool2int(x[s,d,h])) = 1
);

constraint forall(s in Students, d in Days) (
  sum(h in Hours)(bool2int(x[s,d,h])) <= H * bool2int(y[s,d])
);

constraint forall(s in Students, d in Days) (
  sum(h in Hours)(bool2int(x[s,d,h])) <= maxAvail[s,d]
);

constraint forall(s in Undergrads) (
  sum(d in Days, h in Hours)(bool2int(x[s,d,h])) >= minWeeklyU
);

constraint forall(s in Grads) (
  sum(d in Days, h in Hours)(bool2int(x[s,d,h])) >= minWeeklyG
);

constraint forall(s in Students) (
  sum(d in Days)(bool2int(y[s,d])) <= maxShiftsPerWeek
);

constraint forall(d in Days) (
  sum(s in Students)(bool2int(y[s,d])) <= maxStudentsPerDay
);

constraint totalPay10 =
  sum(s in Students, d in Days, h in Hours)(wageInt[s] * bool2int(x[s,d,h]));

solve minimize totalPay10;

output [
  "totalPay(CNY) = ", show(totalPay10 / 10.0), "\n"
];