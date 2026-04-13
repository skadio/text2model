int: nDays = 7;
set of int: DAYS = 1..nDays;

array[DAYS] of float: d = [2.0, 4.0, 4.0, 3.0, 1.0, 2.0, 3.0];

int: L = 5;

array[DAYS] of var float: x;
var float: total_nurses;

constraint forall(i in DAYS)(x[i] >= 0.0);

constraint total_nurses = sum(i in DAYS)(x[i]);

constraint
  forall(j in DAYS)(
    sum(i in DAYS where ((j - i + nDays) mod nDays) <= (L - 1))(x[i]) >= d[j]
  );

solve minimize total_nurses;

output [
  "total_nurses = ", show(total_nurses), "\n",
  "x = ", show(x), "\n"
];