int: Period;
array[1..7] of int: Demand;

set of int: DAYS = 1..7;

int: maxN = sum(demand in Demand)(demand);

array[1..Period] of var 0..maxN: Start;

array[DAYS] of var 0..maxN: Staff;

constraint
  forall(d in DAYS) (
    Staff[d] =
      sum(p in 1..Period, k in 0..p-1)(
        Start[p] * bool2int( ((d - k - 1) mod 7) + 1 == p )
      )
  );

constraint forall(d in DAYS)(Staff[d] >= Demand[d]);

var 0..maxN: TotalNurses = sum(p in 1..Period)(Start[p]);

solve minimize TotalNurses;

output [
  "TotalNurses = ", show(TotalNurses), "\n",
  "Start = ", show(Start), "\n",
  "Staff = ", show(Staff), "\n"
];