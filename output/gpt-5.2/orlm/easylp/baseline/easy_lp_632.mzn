int: c1 = 1000;
int: c2 = 1500;
int: c3 = 2000;
int: c4 = 2500;

% Decision variables: weekly hours (whole numbers)
var 0..100: x1;
var 0..100: x2;
var 0..100: x3;
var 0..100: x4;

constraint x1 + x2 <= 20;
constraint x3 + x4 <= 15;
constraint x1 + x3 >= 10;
constraint x2 + x4 >= 8;

var int: total_fatigue = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_fatigue;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_fatigue=", show(total_fatigue), "\n"
];