include "globals.mzn";

int: N;
array[1..N] of int: Num;
int: WorkingDays;
int: RestingDays;

int: L = WorkingDays + RestingDays;

% s[t] = number of employees whose cycle starts (work day 1) on day t (1..L)
array[1..L] of var 0..sum(Num): s;

% total employees hired
var 0..sum(Num): E = sum(t in 1..L)(s[t]);

% employees working on day d (1..N) given recurring schedule
array[1..N] of var 0..sum(Num): work;

constraint
  forall(d in 1..N) (
    work[d] =
      sum(t in 1..L where ((d - t) mod L + 1) <= WorkingDays)(s[t])
  );

% meet demand each day
constraint forall(d in 1..N) (work[d] >= Num[d]);

solve minimize E;

output [
  "MinEmployees = ", show(E), "\n",
  "StartsPerCycle = ", show(s), "\n",
  "WorkingPerDay = ", show(work), "\n"
];