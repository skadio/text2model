int: W = 4;
int: C = 3;

set of int: WORKSHOPS = 1..W;
set of int: COMPONENTS = 1..C;

array[WORKSHOPS] of float: cap_hours = [100.0, 150.0, 80.0, 200.0];

array[WORKSHOPS, COMPONENTS] of float: rate = array2d(WORKSHOPS, COMPONENTS, [
  10.0, 15.0,  5.0,
  15.0, 10.0,  5.0,
  20.0,  5.0, 10.0,
  10.0, 15.0, 20.0
]);

array[COMPONENTS] of float: ubP_comp = [
  sum(w in WORKSHOPS)(rate[w,c] * cap_hours[w]) | c in COMPONENTS
];

float: UB_P = min(ubP_comp);
float: MAX_H = max(cap_hours);

array[WORKSHOPS, COMPONENTS] of var 0.0..MAX_H: h;
var 0.0..UB_P: P;

constraint forall(w in WORKSHOPS) (
  sum(c in COMPONENTS)(h[w,c]) <= cap_hours[w]
);

constraint forall(c in COMPONENTS) (
  sum(w in WORKSHOPS)(rate[w,c] * h[w,c]) >= P
);

solve maximize P;

output [
  "P = ", show(P), "\n",
  "h = ", show(h), "\n"
];