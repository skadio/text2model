int: N_DAYS = 7;
set of int: DAYS = 1..N_DAYS;

array[DAYS] of float: d = [5.0, 4.0, 7.0, 3.0, 8.0, 4.0, 3.0];
int: WORK_CONSEC = 5;

float: UB = sum(j in DAYS)(d[j]);

array[DAYS] of var float: x;
var float: total_nurses;

constraint forall(i in DAYS)(x[i] >= 0.0 /\ x[i] <= UB);

constraint total_nurses = sum(i in DAYS)(x[i]);

constraint forall(j in DAYS)(
  sum(i in DAYS where ((j - i + N_DAYS) mod N_DAYS) < WORK_CONSEC)(x[i]) >= d[j]
);

solve minimize total_nurses;

output [
  "total_nurses = ", show(total_nurses), "\n",
  "rounded_total_nurses = ", show(round(total_nurses)), "\n"
];