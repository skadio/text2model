int: Period;
set of int: DAYS = 1..7;

array[DAYS] of int: Demand;

set of int: X = 1..6;

array[X, DAYS] of int: cover = array2d(X, DAYS,
  [ if ((d - s + 7) mod 7) < s then 1 else 0 endif
    | s in X, d in DAYS ]
);

array[X] of var 0..sum(Demand): start;

constraint
  forall(d in DAYS)(
    sum(s in X)( start[s] * cover[s,d] ) >= Demand[d]
  );

var 0..sum(Demand): Nurses = sum(s in X)(start[s]);

solve minimize Nurses;

output [
  "Nurses = ", show(Nurses), "\n",
  "start_by_x = ", show([start[s] | s in X]), "\n"
];