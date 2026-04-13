int: maxMinutes = 1000;

float: heart1 = 0.5;
float: brain1 = 0.8;
float: waste1 = 0.3;

float: heart2 = 0.3;
float: brain2 = 1.0;
float: waste2 = 0.5;

float: heartMax = 8.0;
float: brainMin = 4.0;

var 0..maxMinutes: m1; % minutes using machine 1
var 0..maxMinutes: m2; % minutes using machine 2

constraint heart1 * int2float(m1) + heart2 * int2float(m2) <= heartMax;
constraint brain1 * int2float(m1) + brain2 * int2float(m2) >= brainMin;

var float: totalWaste = waste1 * int2float(m1) + waste2 * int2float(m2);

solve minimize totalWaste;

output [
  "Machine1_minutes = ", show(m1), "\n",
  "Machine2_minutes = ", show(m2), "\n",
  "Heart_medicine = ", show(heart1 * int2float(m1) + heart2 * int2float(m2)), "\n",
  "Brain_medicine = ", show(brain1 * int2float(m1) + brain2 * int2float(m2)), "\n",
  "Total_waste = ", show(totalWaste), "\n"
];