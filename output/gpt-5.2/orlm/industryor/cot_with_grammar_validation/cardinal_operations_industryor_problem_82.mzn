int: H = 24;
set of int: HOURS = 0..H-1;

int: SHIFT_LEN = 8;

array[HOURS] of int: demand =
  array1d(HOURS, [4,4,4,4,4,4,8,8,8,8,10,10,10,10,7,7,7,7,12,12,12,12,4,4]);

int: max_demand = max([demand[h] | h in HOURS]);

array[HOURS] of var 0..max_demand: x;

var 0..(H * max_demand): total_waiters = sum(h in HOURS)(x[h]);

constraint
  forall(h in HOURS)(
    sum(s in HOURS where ((h - s + H) mod H) < SHIFT_LEN)(x[s]) >= demand[h]
  );

solve minimize total_waiters;

output [
  "total_waiters = ", show(total_waiters), "\n",
  "x = ", show(x), "\n"
];