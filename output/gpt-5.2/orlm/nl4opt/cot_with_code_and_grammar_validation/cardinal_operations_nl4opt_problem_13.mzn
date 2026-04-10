float: p1 = 0.3;
float: s1 = 0.2;
float: t1 = 0.6;

float: p2 = 0.2;
float: s2 = 0.1;
float: t2 = 0.4;

float: skin_max = 4.0;
float: tumor_min = 3.0;

var 0..200: x1_10;
var 0..200: x2_10;

constraint s1 * (x1_10 / 10.0) + s2 * (x2_10 / 10.0) <= skin_max;
constraint t1 * (x1_10 / 10.0) + t2 * (x2_10 / 10.0) >= tumor_min;

solve minimize p1 * (x1_10 / 10.0) + p2 * (x2_10 / 10.0);

output [
  "x1 (min) = ", show(x1_10 / 10.0), "\n",
  "x2 (min) = ", show(x2_10 / 10.0), "\n",
  "pancreas dose = ", show(p1*(x1_10 / 10.0) + p2*(x2_10 / 10.0)), "\n",
  "skin dose = ", show(s1*(x1_10 / 10.0) + s2*(x2_10 / 10.0)), "\n",
  "tumor dose = ", show(t1*(x1_10 / 10.0) + t2*(x2_10 / 10.0)), "\n"
];