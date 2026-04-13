int: D = 7;
set of int: DAYS = 1..D;

array[DAYS] of float: d = [2.0, 4.0, 4.0, 3.0, 1.0, 2.0, 3.0];

int: L = 5;

array[DAYS] of var float: x;
var float: total_nurses;

constraint forall(i in DAYS) (x[i] >= 0.0);

constraint
  forall(j in DAYS) (
    sum(i in DAYS) (
      x[i] * (if ((j - i + D) mod D) < L then 1.0 else 0.0 endif)
    ) >= d[j]
  );

constraint total_nurses = sum(i in DAYS) (x[i]);

solve minimize total_nurses;

output [
  "total_nurses = ", show(total_nurses), "\n",
  "x = ", show(x), "\n"
];