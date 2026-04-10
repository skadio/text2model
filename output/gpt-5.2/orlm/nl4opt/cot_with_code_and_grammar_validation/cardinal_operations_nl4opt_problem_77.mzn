int: SCALE = 10;

int: heart_rate_m1 = 5;
int: brain_rate_m1 = 8;
int: waste_rate_m1 = 3;

int: heart_rate_m2 = 3;
int: brain_rate_m2 = 10;
int: waste_rate_m2 = 5;

int: heart_max = 80;
int: brain_min = 40;

var 0..100000: x1;
var 0..100000: x2;

var 0..1000000: total_waste;

constraint heart_rate_m1 * x1 + heart_rate_m2 * x2 <= heart_max * SCALE;
constraint brain_rate_m1 * x1 + brain_rate_m2 * x2 >= brain_min * SCALE;

constraint total_waste = waste_rate_m1 * x1 + waste_rate_m2 * x2;

solve minimize total_waste;

output [
  "t1_minutes = ", show(x1), "/", show(SCALE), "\n",
  "t2_minutes = ", show(x2), "/", show(SCALE), "\n",
  "total_waste = ", show(total_waste), "/", show(SCALE * SCALE), "\n"
];