float: throat_per_s1 = 0.5;
float: lung_per_s1 = 0.4;
float: sugar_per_s1 = 0.5;

float: throat_per_s2 = 0.2;
float: lung_per_s2 = 0.5;
float: sugar_per_s2 = 0.3;

float: throat_max = 5.0;
float: lung_min = 4.0;

var float: s1;
var float: s2;

constraint s1 >= 0.0 /\ s1 <= 100.0;
constraint s2 >= 0.0 /\ s2 <= 100.0;

constraint throat_per_s1 * s1 + throat_per_s2 * s2 <= throat_max;
constraint lung_per_s1 * s1 + lung_per_s2 * s2 >= lung_min;

solve minimize sugar_per_s1 * s1 + sugar_per_s2 * s2;

output [
  "s1=", show(s1), "\n",
  "s2=", show(s2), "\n",
  "min_sugar=", show(sugar_per_s1 * s1 + sugar_per_s2 * s2), "\n"
];