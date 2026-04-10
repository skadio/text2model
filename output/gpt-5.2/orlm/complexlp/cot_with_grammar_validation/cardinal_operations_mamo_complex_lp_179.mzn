int: D = 7;
set of int: DAYS = 1..D;

array[DAYS] of float: demand = [5.0, 4.0, 7.0, 3.0, 8.0, 4.0, 3.0];
int: work_len = 5;

array[DAYS] of var 0.0..100.0: x;
var 0.0..1000.0: total_nurses = sum(j in DAYS)(x[j]);

constraint
  forall(j in DAYS)(
    sum(k in 0..work_len-1)(x[1 + ((j - 1 - k + D) mod D)]) >= demand[j]
  );

solve minimize total_nurses;

output [
  "total_nurses=", show(total_nurses), "\n",
  "x=", show(x), "\n"
];