float: heart_rate_m1 = 0.5;
float: brain_rate_m1 = 0.8;
float: waste_rate_m1 = 0.3;

float: heart_rate_m2 = 0.3;
float: brain_rate_m2 = 1.0;
float: waste_rate_m2 = 0.5;

float: heart_max = 8.0;
float: brain_min = 4.0;

var float: t1;
var float: t2;
var float: total_waste;

constraint t1 >= 0.0 /\ t2 >= 0.0;

constraint heart_rate_m1 * t1 + heart_rate_m2 * t2 <= heart_max;
constraint brain_rate_m1 * t1 + brain_rate_m2 * t2 >= brain_min;

constraint total_waste = waste_rate_m1 * t1 + waste_rate_m2 * t2;

solve minimize total_waste;

output [
  "t1=", show(t1), "\n",
  "t2=", show(t2), "\n",
  "total_waste=", show(total_waste), "\n"
];