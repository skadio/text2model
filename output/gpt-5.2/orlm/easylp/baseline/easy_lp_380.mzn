% Sports training camp: minimize total fatigue score with integer hours

var 0..12: x1;
var 0..12: x2;
var 0..16: x3;
var 0..16: x4;

constraint x1 + x2 <= 12;
constraint x3 + x4 <= 16;
constraint x1 + x3 >= 8;
constraint x2 + x4 >= 10;

var int: total_fatigue = 10*x1 + 15*x2 + 20*x3 + 25*x4;

solve minimize total_fatigue;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_fatigue=", show(total_fatigue), "\n"
];